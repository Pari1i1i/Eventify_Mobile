import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void _showEditProfileModal() {
    final user = ref.read(authStateProvider).user;
    if (user == null) return;

    final nameCtrl = TextEditingController(text: user.name);
    final phoneCtrl = TextEditingController(text: user.phone ?? '');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.textBorder, width: 3),
            boxShadow: const [
              BoxShadow(color: AppColors.textBorder, offset: Offset(0, -4)),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'EDIT PROFIL SAYA',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textBorder,
                      ),
                    ),
                    NeoIconButton(
                      icon: LucideIcons.x,
                      size: 32,
                      iconSize: 16,
                      backgroundColor: AppColors.pink,
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const NeoFormLabel('NAMA LENGKAP', isRequired: true),
                NeoTextField(
                  controller: nameCtrl,
                  hint: 'Nama Lengkap',
                  prefixIcon: const Icon(LucideIcons.user, size: 18, color: AppColors.textBorder),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Nama wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                const NeoFormLabel('NOMOR TELEPON / WA'),
                NeoTextField(
                  controller: phoneCtrl,
                  hint: '081234567890',
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(LucideIcons.phone, size: 18, color: AppColors.textBorder),
                ),
                const SizedBox(height: 20),
                NeoButton(
                  text: 'SIMPAN PERUBAHAN',
                  backgroundColor: AppColors.yellow,
                  icon: LucideIcons.save,
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    final success = await ref.read(authStateProvider.notifier).updateProfile(
                      name: nameCtrl.text,
                      phone: phoneCtrl.text.isNotEmpty ? phoneCtrl.text : null,
                    );
                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                    }
                    if (mounted) {
                      if (success) {
                        showNeoSnackBar(context, 'Profil berhasil diperbarui!', isSuccess: true);
                      } else {
                        showNeoSnackBar(context, 'Gagal memperbarui profil', isError: true);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChangePasswordModal() {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.textBorder, width: 3),
            boxShadow: const [
              BoxShadow(color: AppColors.textBorder, offset: Offset(0, -4)),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GANTI KATA SANDI',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textBorder,
                      ),
                    ),
                    NeoIconButton(
                      icon: LucideIcons.x,
                      size: 32,
                      iconSize: 16,
                      backgroundColor: AppColors.pink,
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const NeoFormLabel('KATA SANDI LAMA', isRequired: true),
                NeoTextField(
                  controller: oldPassCtrl,
                  hint: 'Masukkan kata sandi lama',
                  obscureText: true,
                  prefixIcon: const Icon(LucideIcons.lock, size: 18, color: AppColors.textBorder),
                  validator: (val) => val == null || val.isEmpty ? 'Kata sandi lama wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                const NeoFormLabel('KATA SANDI BARU', isRequired: true),
                NeoTextField(
                  controller: newPassCtrl,
                  hint: 'Minimal 6 karakter',
                  obscureText: true,
                  prefixIcon: const Icon(LucideIcons.key, size: 18, color: AppColors.textBorder),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Kata sandi baru wajib diisi';
                    if (val.length < 6) return 'Minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                NeoButton(
                  text: 'UBAH KATA SANDI',
                  backgroundColor: AppColors.pink,
                  icon: LucideIcons.check,
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    final success = await ref.read(authStateProvider.notifier).changePassword(
                      oldPassword: oldPassCtrl.text,
                      newPassword: newPassCtrl.text,
                    );
                    if (ctx.mounted) {
                      Navigator.pop(ctx);
                    }
                    if (mounted) {
                      if (success) {
                        showNeoSnackBar(context, 'Kata sandi berhasil diubah!', isSuccess: true);
                      } else {
                        showNeoSnackBar(context, 'Gagal mengubah kata sandi', isError: true);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showServerSettingsModal() {
    final serverController = TextEditingController(text: ApiConstants.baseUrl);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.textBorder, width: 3),
            boxShadow: const [
              BoxShadow(color: AppColors.textBorder, offset: Offset(0, -4)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PENGATURAN SERVER API',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textBorder,
                    ),
                  ),
                  NeoIconButton(
                    icon: LucideIcons.x,
                    size: 32,
                    iconSize: 16,
                    backgroundColor: AppColors.pink,
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const NeoFormLabel('BASE URL BACKEND REST API'),
              NeoTextField(
                controller: serverController,
                hint: 'http://139.190.96.203:8093/api/v1',
                prefixIcon: const Icon(LucideIcons.globe, size: 18, color: AppColors.textBorder),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: [
                  NeoOutlineButton(
                    text: 'Cloud VPS (139.190.96.203)',
                    fontSize: 10,
                    height: 32,
                    onPressed: () => serverController.text = 'http://139.190.96.203:8093/api/v1',
                  ),
                  NeoOutlineButton(
                    text: 'Localhost (8080)',
                    fontSize: 10,
                    height: 32,
                    onPressed: () => serverController.text = 'http://localhost:8080/api/v1',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              NeoButton(
                text: 'SIMPAN & TERAPKAN',
                backgroundColor: AppColors.teal,
                onPressed: () {
                  final newUrl = serverController.text.trim();
                  if (newUrl.isNotEmpty) {
                    ref.read(dioClientProvider).updateBaseUrl(newUrl);
                    Navigator.pop(ctx);
                    showNeoSnackBar(context, 'Base URL diubah ke: $newUrl', isSuccess: true);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    if (!authState.isAuthenticated || user == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const NeoAppBar(
          title: 'EVENTIFY',
          subtitleTag: 'PROFIL',
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: NeoCard(
              backgroundColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.yellow,
                      border: Border.all(color: AppColors.textBorder, width: 2),
                      boxShadow: const [
                        BoxShadow(color: AppColors.textBorder, offset: Offset(3, 3)),
                      ],
                    ),
                    child: const Icon(LucideIcons.user, size: 32, color: AppColors.textBorder),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ANDA BELUM MASUK',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textBorder,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Silakan masuk akun Anda untuk mengelola tiket, pesanan, dan event.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  NeoButton(
                    text: 'MASUK SEKARANG',
                    icon: LucideIcons.logIn,
                    backgroundColor: AppColors.pink,
                    onPressed: () => context.push('/login'),
                  ),
                  const SizedBox(height: 10),
                  NeoOutlineButton(
                    text: 'PENGATURAN SERVER API',
                    icon: LucideIcons.settings,
                    fullWidth: true,
                    onPressed: _showServerSettingsModal,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Color roleColor = AppColors.teal;
    if (user.isAdmin) roleColor = AppColors.pink;
    if (user.isOrganizer) roleColor = AppColors.yellow;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'PROFIL SAYA',
        actions: [
          NeoIconButton(
            icon: LucideIcons.settings,
            backgroundColor: AppColors.mint,
            size: 38,
            iconSize: 18,
            onPressed: _showServerSettingsModal,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Profile Card
            NeoCard(
              backgroundColor: Colors.white,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: roleColor,
                          border: Border.all(color: AppColors.textBorder, width: 2.5),
                          boxShadow: const [
                            BoxShadow(color: AppColors.textBorder, offset: Offset(3, 3)),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textBorder,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textBorder,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.email,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            NeoBadge(
                              label: user.isAdmin ? 'ADMINISTRATOR' : user.role.toUpperCase(),
                              backgroundColor: roleColor,
                              textColor: AppColors.textBorder,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (user.isAdmin) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.pink.withValues(alpha: 0.3),
                        border: Border.all(color: AppColors.textBorder, width: 1.5),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.shieldCheck, size: 18, color: AppColors.textBorder),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Akun Administrator terdeteksi. Manajemen user, verifikasi event & statistik lengkap dikelola melalui Eventify Web Portal (Desktop).',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textBorder,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (user.phone != null && user.phone!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.textBorder, thickness: 1.5),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(LucideIcons.phone, size: 16, color: AppColors.textBorder),
                        const SizedBox(width: 8),
                        Text(
                          user.phone!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBorder,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Profile Actions
            NeoCard(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.yellow,
                        border: Border.all(color: AppColors.textBorder, width: 1.5),
                      ),
                      child: const Icon(LucideIcons.userCheck, size: 18, color: AppColors.textBorder),
                    ),
                    title: Text(
                      'Edit Profil',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textBorder,
                      ),
                    ),
                    subtitle: Text(
                      'Ubah nama & info kontak',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    trailing: const Icon(LucideIcons.chevronRight, size: 18, color: AppColors.textBorder),
                    onTap: _showEditProfileModal,
                  ),
                  const Divider(color: AppColors.divider, thickness: 1.5),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.orange,
                        border: Border.all(color: AppColors.textBorder, width: 1.5),
                      ),
                      child: const Icon(LucideIcons.key, size: 18, color: AppColors.textBorder),
                    ),
                    title: Text(
                      'Ganti Kata Sandi',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textBorder,
                      ),
                    ),
                    subtitle: Text(
                      'Perbarui keamanan akun Anda',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    trailing: const Icon(LucideIcons.chevronRight, size: 18, color: AppColors.textBorder),
                    onTap: _showChangePasswordModal,
                  ),
                  const Divider(color: AppColors.divider, thickness: 1.5),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.blueLight,
                        border: Border.all(color: AppColors.textBorder, width: 1.5),
                      ),
                      child: const Icon(LucideIcons.server, size: 18, color: AppColors.textBorder),
                    ),
                    title: Text(
                      'Konfigurasi Server API',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textBorder,
                      ),
                    ),
                    subtitle: Text(
                      ApiConstants.baseUrl,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    trailing: const Icon(LucideIcons.chevronRight, size: 18, color: AppColors.textBorder),
                    onTap: _showServerSettingsModal,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Logout Button
            NeoButton(
              text: 'KELUAR DARI AKUN',
              icon: LucideIcons.logOut,
              backgroundColor: AppColors.pink,
              onPressed: () async {
                await ref.read(authStateProvider.notifier).logout();
                if (context.mounted) {
                  showNeoSnackBar(context, 'Berhasil keluar', isSuccess: true);
                }
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

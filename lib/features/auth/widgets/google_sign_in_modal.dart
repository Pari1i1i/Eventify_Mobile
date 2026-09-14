import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/google_icon.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../providers/auth_provider.dart';

void showGoogleSignInModal(BuildContext context, WidgetRef ref) {
  final emailCtrl = TextEditingController(text: 'user@gmail.com');
  final nameCtrl = TextEditingController(text: 'Pengguna Google');
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setModalState) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.textBorder, width: 3),
            boxShadow: const [
              BoxShadow(
                color: AppColors.textBorder,
                offset: Offset(0, -4),
                blurRadius: 0,
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const GoogleIcon(size: 24),
                        const SizedBox(width: 10),
                        Text(
                          'MASUK DENGAN GOOGLE',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textBorder,
                          ),
                        ),
                      ],
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
                const SizedBox(height: 14),
                Text(
                  'Pilih atau masukkan akun Google Anda untuk login instan tanpa perlu mengingat kata sandi.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),

                // Quick One-Tap Profile Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.toska.withValues(alpha: 0.3),
                    border: Border.all(color: AppColors.textBorder, width: 2),
                    boxShadow: const [
                      BoxShadow(color: AppColors.textBorder, offset: Offset(2.5, 2.5)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.yellow,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.textBorder, width: 2),
                        ),
                        child: const Center(
                          child: GoogleIcon(size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nameCtrl.text.isNotEmpty ? nameCtrl.text : 'Akun Google',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textBorder,
                              ),
                            ),
                            Text(
                              emailCtrl.text,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(LucideIcons.checkCircle2, color: Colors.green, size: 20),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                const NeoFormLabel('EMAIL GOOGLE (@gmail.com)', isRequired: true),
                NeoTextField(
                  controller: emailCtrl,
                  hint: 'nama@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(LucideIcons.mail, size: 18, color: AppColors.textBorder),
                  onChanged: (_) => setModalState(() {}),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Email Google wajib diisi';
                    if (!Formatters.isValidEmail(val)) return 'Format email tidak valid';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                const NeoFormLabel('NAMA PENGGUNA'),
                NeoTextField(
                  controller: nameCtrl,
                  hint: 'Nama Anda di Google',
                  prefixIcon: const Icon(LucideIcons.user, size: 18, color: AppColors.textBorder),
                  onChanged: (_) => setModalState(() {}),
                ),
                const SizedBox(height: 20),

                // Button submit
                NeoButton(
                  text: 'LANJUTKAN DENGAN GOOGLE',
                  backgroundColor: AppColors.yellow,
                  isLoading: isLoading,
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    setModalState(() => isLoading = true);

                    final success = await ref.read(authStateProvider.notifier).loginWithGoogle(
                      email: emailCtrl.text.trim(),
                      name: nameCtrl.text.trim(),
                    );

                    if (ctx.mounted) {
                      setModalState(() => isLoading = false);
                      Navigator.pop(ctx);
                      if (success) {
                        showNeoSnackBar(context, 'Login Google berhasil!', isSuccess: true);
                        context.go('/home');
                      } else {
                        final err = ref.read(authStateProvider).errorMessage ?? 'Gagal login dengan Google';
                        showNeoSnackBar(context, err, isError: true);
                      }
                    }
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

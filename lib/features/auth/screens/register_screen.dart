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

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authStateProvider.notifier).register(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
      role: 'customer', // Default role for public registration is always customer / peserta
    );

    if (mounted) {
      if (success) {
        showNeoSnackBar(context, 'Pendaftaran berhasil!', isSuccess: true);
        context.go('/home');
      } else {
        final err = ref.read(authStateProvider).errorMessage ?? 'Gagal mendaftar';
        showNeoSnackBar(context, err, isError: true);
      }
    }
  }

  void _handleGoogleSignIn() async {
    final success = await ref.read(authStateProvider.notifier).triggerGoogleSignIn();
    if (mounted && success) {
      showNeoSnackBar(context, 'Pendaftaran Google berhasil!', isSuccess: true);
      context.go('/home');
    } else if (mounted) {
      final err = ref.read(authStateProvider).errorMessage;
      if (err != null && err.isNotEmpty) {
        showNeoSnackBar(context, err, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'DAFTAR AKUN',
        showBackButton: true,
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Banner
                NeoCard(
                  backgroundColor: AppColors.teal,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: AppColors.textBorder, width: 2),
                        ),
                        child: const Icon(LucideIcons.userPlus, size: 24, color: AppColors.textBorder),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DAFTAR AKUN PESERTA',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textBorder,
                              ),
                            ),
                            Text(
                              'Beli tiket, simpan e-tiket offline & check-in instan',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Google Register Native Button
                GestureDetector(
                  onTap: authState.isLoading ? null : _handleGoogleSignIn,
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.textBorder, width: 2.5),
                      boxShadow: const [
                        BoxShadow(color: AppColors.textBorder, offset: Offset(4, 4), blurRadius: 0),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const GoogleIcon(size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'DAFTAR DENGAN GOOGLE',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textBorder,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Divider Or
                Row(
                  children: [
                    const Expanded(child: Divider(color: AppColors.textBorder, thickness: 1.5)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'ATAU EMAIL MANUAL',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: AppColors.textBorder, thickness: 1.5)),
                  ],
                ),

                const SizedBox(height: 16),

                // Form Inputs Card
                NeoCard(
                  backgroundColor: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const NeoFormLabel('NAMA LENGKAP', isRequired: true),
                      NeoTextField(
                        controller: _nameController,
                        hint: 'Nama Lengkap Anda',
                        prefixIcon: const Icon(LucideIcons.user, size: 18, color: AppColors.textBorder),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Nama lengkap wajib diisi';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      const NeoFormLabel('ALAMAT EMAIL', isRequired: true),
                      NeoTextField(
                        controller: _emailController,
                        hint: 'nama@domain.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(LucideIcons.mail, size: 18, color: AppColors.textBorder),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Email wajib diisi';
                          }
                          if (!Formatters.isValidEmail(val)) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      const NeoFormLabel('KATA SANDI', isRequired: true),
                      NeoTextField(
                        controller: _passwordController,
                        hint: 'Minimal 6 karakter',
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(LucideIcons.lock, size: 18, color: AppColors.textBorder),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                            size: 18,
                            color: AppColors.textBorder,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Kata sandi wajib diisi';
                          }
                          if (val.length < 6) {
                            return 'Kata sandi minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      const NeoFormLabel('KONFIRMASI KATA SANDI', isRequired: true),
                      NeoTextField(
                        controller: _confirmPasswordController,
                        hint: 'Ulangi kata sandi',
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(LucideIcons.shieldCheck, size: 18, color: AppColors.textBorder),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Konfirmasi kata sandi wajib diisi';
                          }
                          if (val != _passwordController.text) {
                            return 'Kata sandi konfirmasi tidak cocok';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),

                      // Information Badge for Organizer
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.toska.withValues(alpha: 0.3),
                          border: Border.all(color: AppColors.textBorder, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(LucideIcons.info, size: 16, color: AppColors.textBorder),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Ingin jadi Panitia? Daftarkan akun Anda lalu hubungi Administrator via Web Portal untuk upgrade role.',
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

                      const SizedBox(height: 20),
                      NeoButton(
                        text: 'DAFTAR SEKARANG',
                        icon: LucideIcons.check,
                        backgroundColor: AppColors.yellow,
                        isLoading: authState.isLoading,
                        onPressed: _handleRegister,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                NeoCard(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sudah punya akun?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBorder,
                        ),
                      ),
                      NeoOutlineButton(
                        text: 'MASUK AKUN',
                        backgroundColor: AppColors.toska,
                        fontSize: 11,
                        height: 36,
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/google_icon.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authStateProvider.notifier).login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (mounted) {
      if (success) {
        showNeoSnackBar(context, 'Login berhasil!', isSuccess: true);
        context.go('/home');
      } else {
        final err = ref.read(authStateProvider).errorMessage ?? 'Gagal login';
        showNeoSnackBar(context, err, isError: true);
      }
    }
  }

  void _handleGoogleSignIn() async {
    final success = await ref.read(authStateProvider.notifier).triggerGoogleSignIn();
    if (mounted && success) {
      showNeoSnackBar(context, 'Login Google berhasil!', isSuccess: true);
      context.go('/home');
    } else if (mounted) {
      final err = ref.read(authStateProvider).errorMessage;
      if (err != null && err.isNotEmpty) {
        showNeoSnackBar(context, err, isError: true);
      }
    }
  }

  void _showServerSettingsModal() {
    final serverController = TextEditingController(text: ApiConstants.baseUrl);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.background,
            border: Border.all(color: AppColors.textBorder, width: 3),
            boxShadow: const [
              BoxShadow(
                color: AppColors.textBorder,
                offset: Offset(0, -4),
                blurRadius: 0,
              ),
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
                    'PENGATURAN SERVER BACKEND',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
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
              const NeoFormLabel('BASE URL API (REST V1)'),
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
                text: 'SIMPAN PENGATURAN',
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'MASUK AKUN',
        showBackButton: true,
        onBack: () => context.go('/home'),
        actions: [
          NeoIconButton(
            icon: LucideIcons.settings,
            tooltip: 'Konfigurasi Server API',
            backgroundColor: AppColors.mint,
            size: 38,
            iconSize: 18,
            onPressed: _showServerSettingsModal,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title Header Card
                  NeoCard(
                    backgroundColor: AppColors.yellow,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: AppColors.textBorder, width: 2),
                              ),
                              child: const Icon(LucideIcons.logIn, size: 24, color: AppColors.textBorder),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'SELAMAT DATANG',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textBorder,
                                    ),
                                  ),
                                  Text(
                                    'Masuk untuk beli tiket & kelola event',
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
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Google Sign In Native Button
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
                            'MASUK DENGAN GOOGLE',
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
                          'ATAU LOGIN EMAIL',
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

                  // Login Form Card
                  NeoCard(
                    backgroundColor: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const NeoFormLabel('EMAIL / USERNAME', isRequired: true),
                        NeoTextField(
                          controller: _emailController,
                          hint: 'user@eventify.id',
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
                        const SizedBox(height: 16),
                        const NeoFormLabel('KATA SANDI', isRequired: true),
                        NeoTextField(
                          controller: _passwordController,
                          hint: 'Masukkan kata sandi',
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
                        const SizedBox(height: 24),
                        NeoButton(
                          text: 'MASUK SEKARANG',
                          icon: LucideIcons.arrowRight,
                          backgroundColor: AppColors.pink,
                          isLoading: authState.isLoading,
                          onPressed: _handleLogin,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Register link
                  NeoCard(
                    backgroundColor: AppColors.toska,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Belum punya akun?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBorder,
                          ),
                        ),
                        NeoOutlineButton(
                          text: 'DAFTAR DI SINI',
                          backgroundColor: Colors.white,
                          fontSize: 11,
                          height: 36,
                          onPressed: () => context.push('/register'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

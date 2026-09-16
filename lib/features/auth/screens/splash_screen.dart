import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    // Small splash delay for visual branding
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    await ref.read(authStateProvider.notifier).checkAuthStatus();
    if (!mounted) return;

    final authState = ref.read(authStateProvider);
    if (authState.isAuthenticated) {
      final role = authState.user?.role.toLowerCase() ?? 'customer';
      if (role == 'organizer' || role == 'panitia' || role == 'admin') {
        context.go('/organizer/dashboard');
      } else {
        context.go('/home');
      }
    } else {
      context.go('/home'); // Unauthenticated users can view Home catalog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.textBorder,
                border: Border.all(color: AppColors.textBorder, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(6, 6),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Text(
                'EVENTIFY',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 3.0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.mint,
                border: Border.all(color: AppColors.textBorder, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.textBorder,
                    offset: Offset(3, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Text(
                'TIKET & PRESENSI EVENT',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textBorder,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.textBorder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

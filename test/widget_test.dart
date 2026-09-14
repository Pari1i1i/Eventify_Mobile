import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eventify/core/widgets/neo_widgets.dart';
import 'package:eventify/core/widgets/google_icon.dart';
import 'package:eventify/features/auth/screens/login_screen.dart';
import 'package:eventify/features/auth/screens/register_screen.dart';
import 'package:eventify/core/storage/local_cache_service.dart';
import 'package:eventify/core/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Neobrutalism Widgets Tests', () {
    testWidgets('NeoButton renders text and triggers callback', (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeoButton(
              text: 'KLIK SAYA',
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('KLIK SAYA'), findsOneWidget);
      await tester.tap(find.text('KLIK SAYA'));
      expect(pressed, true);
    });

    testWidgets('GoogleIcon renders custom painter cleanly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GoogleIcon(size: 24),
          ),
        ),
      );

      expect(find.byType(GoogleIcon), findsOneWidget);
    });
  });

  group('Auth Screens Smoke Tests', () {
    testWidgets('LoginScreen renders Google Login and form inputs', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final pref = await SharedPreferences.getInstance();
      final cacheService = LocalCacheService(pref);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localCacheServiceProvider.overrideWithValue(cacheService),
          ],
          child: const MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      expect(find.text('MASUK DENGAN GOOGLE'), findsOneWidget);
      expect(find.text('MASUK SEKARANG'), findsOneWidget);
      expect(find.text('SELAMAT DATANG'), findsOneWidget);
    });

    testWidgets('RegisterScreen defaults to Peserta without role dropdown', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      final pref = await SharedPreferences.getInstance();
      final cacheService = LocalCacheService(pref);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localCacheServiceProvider.overrideWithValue(cacheService),
          ],
          child: const MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      expect(find.text('DAFTAR AKUN PESERTA'), findsOneWidget);
      expect(find.text('DAFTAR DENGAN GOOGLE'), findsOneWidget);
      expect(find.text('DAFTAR SEKARANG'), findsOneWidget);
      // Ensure no organizer choice dropdown exists in public registration
      expect(find.text('PERAN AKUN (ROLE)'), findsNothing);
    });
  });
}

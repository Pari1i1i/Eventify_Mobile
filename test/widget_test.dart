import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventify/admin/data/admin_mock_data.dart';
import 'package:eventify/admin/admin_login.dart';
import 'package:eventify/admin/admin_main_navigation.dart';

void main() {
  group('AdminMockDataService Tests', () {
    test('Initial data should contain events and at least 1 panitia', () {
      final service = AdminMockDataService();
      expect(service.events.isNotEmpty, true);
      expect(service.totalEvent >= 3, true);
      expect(service.panitiaList.isNotEmpty, true);

      // Cek event #2 sudah memiliki panitia Budi Santoso
      final event2 = service.getEventById('evt-2');
      expect(event2, isNotNull);
      expect(event2?.panitiaEmail, 'budi.soundwave@eventify.id');
    });

    test('tambahPanitia should assign panitia to event and update event status', () {
      final service = AdminMockDataService();
      final initialCount = service.totalPanitiaTerdaftar;

      // Tugaskan panitia ke event #1
      final success = service.tambahPanitia(
        nama: 'Sarah Jessica',
        email: 'sarah.uiux@eventify.id',
        password: 'Password123!',
        eventId: 'evt-1',
      );

      expect(success, true);
      expect(service.totalPanitiaTerdaftar, initialCount + 1);

      final event1 = service.getEventById('evt-1');
      expect(event1?.panitiaEmail, 'sarah.uiux@eventify.id');
      expect(event1?.panitiaNama, 'Sarah Jessica');
    });

    test('resetPassword should update panitia password', () {
      final service = AdminMockDataService();
      final panitia = service.panitiaList.first;

      final success = service.resetPassword(panitia.id, 'NewSecurePass999!');
      expect(success, true);

      final updated = service.panitiaList.firstWhere((p) => p.id == panitia.id);
      expect(updated.password, 'NewSecurePass999!');
    });

    test('hapusPanitia should remove panitia and unlink from event', () {
      final service = AdminMockDataService();
      final panitia = service.panitiaList.first;
      final assignedEventId = panitia.eventId;

      final success = service.hapusPanitia(panitia.id);
      expect(success, true);

      final event = service.getEventById(assignedEventId);
      expect(event?.panitiaEmail, isNull);
    });
  });

  group('Admin Widget Smoke Tests', () {
    testWidgets('AdminLoginPage renders login elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AdminLoginPage(),
        ),
      );

      expect(find.text('MASUK SEBAGAI ADMIN'), findsOneWidget);
      expect(find.text('PORTAL ADMINISTRATOR'), findsOneWidget);
      expect(find.text('Masuk sebagai Admin'), findsOneWidget);
    });

    testWidgets('AdminMainNavigation renders dashboard tab by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AdminMainNavigation(),
        ),
      );

      expect(find.text('DASHBOARD ADMIN'), findsOneWidget);
      expect(find.text('Beranda Event'), findsOneWidget);
      expect(find.text('Kelola Panitia'), findsOneWidget);
      expect(find.text('Akun Panitia'), findsOneWidget);
    });
  });
}

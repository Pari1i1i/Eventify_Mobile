import 'package:flutter_test/flutter_test.dart';
import 'package:eventify/core/utils/formatters.dart';
import 'package:eventify/features/auth/models/user_model.dart';
import 'package:eventify/features/events/models/event_model.dart';
import 'package:eventify/features/orders/models/order_model.dart';
import 'package:eventify/features/tickets/models/ticket_model.dart';
import 'package:eventify/features/scanner/models/scan_result_model.dart';

void main() {
  group('Formatters Tests', () {
    test('Format currency returns Gratis for 0 or null and Rp format for numbers', () {
      expect(Formatters.formatCurrency(0), 'Gratis');
      expect(Formatters.formatCurrency(null), 'Gratis');
      expect(Formatters.formatCurrency(150000), contains('150.000'));
    });

    test('Valid email checking', () {
      expect(Formatters.isValidEmail('user@eventify.id'), true);
      expect(Formatters.isValidEmail('invalid-email'), false);
    });
  });

  group('Models Serialization Tests', () {
    test('UserModel serialization and role getters', () {
      final json = {
        'id': 1,
        'name': 'Budi Panitia',
        'email': 'budi@eventify.id',
        'role': 'organizer',
        'phone': '08123456789',
      };
      final user = UserModel.fromJson(json);
      expect(user.id, 1);
      expect(user.name, 'Budi Panitia');
      expect(user.isOrganizer, true);
      expect(user.isCustomer, false);
      expect(user.isAdmin, false);
    });

    test('EventModel & TicketTierModel parsing', () {
      final json = {
        'id': 10,
        'name': '8Finity Fun Run 2026',
        'slug': '8finity-fun-run-2026',
        'description': 'Charity Fun Run Event',
        'category': 'Olahraga & Lari',
        'location': 'Gelora Bung Karno',
        'city': 'Jakarta',
        'ticket_tiers': [
          {
            'id': 1,
            'event_id': 10,
            'name': 'Early Bird 5K',
            'price': 150000,
            'quota': 200,
            'remaining_quota': 50,
          },
        ],
      };
      final event = EventModel.fromJson(json);
      expect(event.id, 10);
      expect(event.title, '8Finity Fun Run 2026');
      expect(event.ticketTiers.length, 1);
      expect(event.ticketTiers.first.name, 'Early Bird 5K');
      expect(event.startingPrice, 150000);
      expect(event.ticketTiers.first.isSoldOut, false);
    });

    test('OrderModel parsing', () {
      final json = {
        'id': 55,
        'order_code': 'ORD-202609-001',
        'user_id': 1,
        'event_id': 10,
        'total_amount': 300000,
        'payment_status': 'paid',
        'payment_method': 'QRIS',
      };
      final order = OrderModel.fromJson(json);
      expect(order.orderCode, 'ORD-202609-001');
      expect(order.isPaid, true);
      expect(order.totalAmount, 300000);
    });

    test('TicketModel parsing', () {
      final json = {
        'id': 101,
        'code': 'EVT-RUN-001',
        'order_id': 55,
        'event_id': 10,
        'customer_name': 'Ahmad Fauzi',
        'status': 'valid',
      };
      final ticket = TicketModel.fromJson(json);
      expect(ticket.ticketCode, 'EVT-RUN-001');
      expect(ticket.isValid, true);
      expect(ticket.attendeeName, 'Ahmad Fauzi');
    });

    test('ScanResultModel parsing', () {
      final json = {
        'status': 'success',
        'message': 'Check-in berhasil untuk gate 1',
        'data': {
          'ticket_code': 'EVT-RUN-001',
          'attendee_name': 'Ahmad Fauzi',
          'tier_name': 'VIP 10K',
        },
      };
      final scan = ScanResultModel.fromJson(json, 'EVT-RUN-001');
      expect(scan.isSuccess, true);
      expect(scan.attendeeName, 'Ahmad Fauzi');
    });
  });
}

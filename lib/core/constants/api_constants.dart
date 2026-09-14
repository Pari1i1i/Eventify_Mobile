import 'package:flutter/foundation.dart';

class ApiConstants {
  // Default Base URL for API
  static String get defaultBaseUrl {
    if (kIsWeb) {
      return 'http://localhost:8080/api/v1';
    }
    // By default, localhost:8080 works on Android device with adb reverse and desktop
    return 'http://localhost:8080/api/v1';
  }

  // Active Base URL (stored in SharedPreferences if custom)
  static String baseUrl = defaultBaseUrl;

  // Storage Keys
  static const String tokenKey = 'eventify_jwt_token';
  static const String userKey = 'eventify_user_data';
  static const String customBaseUrlKey = 'eventify_custom_base_url';
  static const String cachedTicketsKey = 'eventify_cached_tickets';
  static const String cachedEventsKey = 'eventify_cached_events';

  // Endpoints: Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String changePassword = '/auth/change-password';

  // Endpoints: Events (Customer)
  static const String events = '/events';
  static String eventDetail(String slug) => '/events/$slug';

  // Endpoints: Orders & Checkout
  static const String orders = '/orders';
  static String orderDetail(String code) => '/orders/$code';
  static const String myOrders = '/orders/my-orders';

  // Endpoints: Tickets
  static const String myTickets = '/tickets/my-tickets';
  static String ticketDetail(String code) => '/tickets/$code';

  // Endpoints: Organizer (Panitia)
  static const String organizerMyEvents = '/organizer/my-events';
  static const String organizerEvents = '/organizer/events';
  static String organizerEventDetail(int id) => '/organizer/events/$id';
  static String organizerEventBanner(int id) => '/organizer/events/$id/banner';
  static const String organizerTicketTiers = '/organizer/ticket-tiers';
  static String organizerTicketTierDetail(int id) => '/organizer/ticket-tiers/$id';

  // Endpoints: Scanner
  static const String scannerCheckIn = '/scanner/check-in';

  // Endpoints: Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static String adminUserRole(int id) => '/admin/users/$id/role';
  static const String adminOrders = '/admin/orders';
}

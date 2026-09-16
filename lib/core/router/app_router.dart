import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/profile_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/events/models/event_model.dart';
import '../../features/events/screens/event_detail_screen.dart';
import '../../features/events/screens/home_events_screen.dart';
import '../../features/orders/models/order_model.dart';
import '../../features/orders/screens/checkout_screen.dart';
import '../../features/orders/screens/my_orders_screen.dart';
import '../../features/orders/screens/payment_screen.dart';
import '../../features/organizer/screens/create_edit_event_screen.dart';
import '../../features/organizer/screens/manage_ticket_tiers_screen.dart';
import '../../features/organizer/screens/organizer_events_screen.dart';
import '../../features/scanner/screens/scanner_screen.dart';
import '../../features/tickets/models/ticket_model.dart';
import '../../features/tickets/screens/my_tickets_screen.dart';
import '../../features/tickets/screens/ticket_detail_screen.dart';
import '../widgets/main_shell_nav.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Splash Screen
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main Shell Route with Dynamic Role Navigation (Customer / Panitia)
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => MainShellNav(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeEventsScreen(),
          ),
          GoRoute(
            path: '/tickets',
            builder: (context, state) => const MyTicketsScreen(),
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => const MyOrdersScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/organizer/dashboard',
            builder: (context, state) => const OrganizerDashboardScreen(),
          ),
          GoRoute(
            path: '/organizer/my-events',
            builder: (context, state) => const OrganizerEventsScreen(),
          ),
          GoRoute(
            path: '/scanner',
            builder: (context, state) => const ScannerScreen(),
          ),
        ],
      ),

      // Event Detail
      GoRoute(
        path: '/events/:slug',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          final event = state.extra as EventModel?;
          return EventDetailScreen(slug: slug, initialEvent: event);
        },
      ),

      // Checkout & Payment
      GoRoute(
        path: '/checkout',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final event = extra['event'] as EventModel;
          final selectedTiers = extra['selectedTiers'] as List<Map<String, dynamic>>? ?? [];
          final totalAmount = extra['totalAmount'] as num? ?? 0;
          return CheckoutScreen(
            event: event,
            selectedTiers: selectedTiers,
            totalAmount: totalAmount,
          );
        },
      ),
      GoRoute(
        path: '/payment/:orderCode',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final orderCode = state.pathParameters['orderCode'] ?? '';
          final order = state.extra as OrderModel?;
          return PaymentScreen(
            orderCode: orderCode,
            initialOrder: order,
          );
        },
      ),

      // Ticket Detail
      GoRoute(
        path: '/tickets/:ticketCode',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final ticketCode = state.pathParameters['ticketCode'] ?? '';
          final ticket = state.extra as TicketModel?;
          return TicketDetailScreen(
            ticketCode: ticketCode,
            initialTicket: ticket,
          );
        },
      ),

      // Organizer Event Management
      GoRoute(
        path: '/organizer/create-event',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const CreateEditEventScreen(),
      ),
      GoRoute(
        path: '/organizer/edit-event/:id',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          final event = state.extra as EventModel?;
          return CreateEditEventScreen(
            eventId: id,
            initialEvent: event,
          );
        },
      ),
      GoRoute(
        path: '/organizer/events/:id/tiers',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
          final event = state.extra as EventModel?;
          return ManageTicketTiersScreen(
            eventId: id,
            initialEvent: event,
          );
        },
      ),
    ],
  );
});

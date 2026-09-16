import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../constants/app_colors.dart';
import '../../features/auth/providers/auth_provider.dart';

class ShellNavigationItem {
  final String label;
  final IconData icon;
  final String route;

  const ShellNavigationItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}

class MainShellNav extends ConsumerWidget {
  final Widget child;

  const MainShellNav({super.key, required this.child});

  List<ShellNavigationItem> _getItemsForRole(String role, bool isAuthenticated) {
    if (!isAuthenticated) {
      return const [
        ShellNavigationItem(label: 'Beranda', icon: LucideIcons.compass, route: '/home'),
        ShellNavigationItem(label: 'Tiket Saya', icon: LucideIcons.ticket, route: '/tickets'),
        ShellNavigationItem(label: 'Pesanan', icon: LucideIcons.receipt, route: '/orders'),
        ShellNavigationItem(label: 'Profil', icon: LucideIcons.user, route: '/profile'),
      ];
    }

    final lower = role.toLowerCase();
    // Organizer & Admin use the Organizer toolkit on mobile (Dashboard + Kelola Event + Scanner + Profil)
    // Admin management (User roles, stats, config) is strictly handled in React Web
    if (lower == 'organizer' || lower == 'panitia' || lower == 'admin') {
      return const [
        ShellNavigationItem(label: 'Dashboard', icon: LucideIcons.layoutDashboard, route: '/organizer/dashboard'),
        ShellNavigationItem(label: 'Kelola Event', icon: LucideIcons.calendar, route: '/organizer/my-events'),
        ShellNavigationItem(label: 'Scanner', icon: LucideIcons.qrCode, route: '/scanner'),
        ShellNavigationItem(label: 'Profil', icon: LucideIcons.user, route: '/profile'),
      ];
    }

    // Default Customer / Peserta
    return const [
      ShellNavigationItem(label: 'Beranda', icon: LucideIcons.compass, route: '/home'),
      ShellNavigationItem(label: 'Tiket Saya', icon: LucideIcons.ticket, route: '/tickets'),
      ShellNavigationItem(label: 'Pesanan', icon: LucideIcons.receipt, route: '/orders'),
      ShellNavigationItem(label: 'Profil', icon: LucideIcons.user, route: '/profile'),
    ];
  }

  int _calculateSelectedIndex(BuildContext context, List<ShellNavigationItem> items) {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < items.length; i++) {
      if (location == items[i].route || (items[i].route != '/home' && location.startsWith(items[i].route))) {
        return i;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final role = authState.user?.role ?? 'customer';
    final items = _getItemsForRole(role, authState.isAuthenticated);
    final selectedIndex = _calculateSelectedIndex(context, items);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppColors.textBorder, width: 3),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.textBorder,
              offset: Offset(0, -2),
              blurRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                final item = items[index];
                final isSelected = index == selectedIndex;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (index != selectedIndex) {
                        context.go(item.route);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.yellow : Colors.transparent,
                        border: isSelected
                            ? Border.all(color: AppColors.textBorder, width: 2)
                            : Border.all(color: Colors.transparent, width: 2),
                        boxShadow: isSelected
                            ? const [
                                BoxShadow(
                                  color: AppColors.textBorder,
                                  offset: Offset(2, 2),
                                  blurRadius: 0,
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.icon,
                            size: 20,
                            color: AppColors.textBorder,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                              color: AppColors.textBorder,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

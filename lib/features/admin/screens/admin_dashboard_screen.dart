import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../providers/admin_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(adminDashboardStatsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'ADMIN PANEL',
        actions: [
          NeoIconButton(
            icon: LucideIcons.refreshCw,
            backgroundColor: AppColors.yellow,
            size: 38,
            iconSize: 18,
            onPressed: () => ref.refresh(adminDashboardStatsProvider),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.textBorder,
        backgroundColor: AppColors.yellow,
        onRefresh: () async {
          ref.invalidate(adminDashboardStatsProvider);
        },
        child: statsAsync.when(
          loading: () => const NeoLoadingIndicator(text: 'Memuat dashboard statistik...'),
          error: (err, _) => NeoErrorState(
            message: err.toString(),
            onRetry: () => ref.refresh(adminDashboardStatsProvider),
          ),
          data: (stats) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Admin Welcome Banner
                  NeoCard(
                    backgroundColor: AppColors.yellow,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.textBorder, width: 2),
                          ),
                          child: const Icon(LucideIcons.shieldAlert, size: 24, color: AppColors.textBorder),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DASHBOARD UTAMA SISTEM',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textBorder,
                                ),
                              ),
                              Text(
                                'Monitoring real-time event, tiket, transaksi & user',
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

                  // Big Stats Grid
                  Text(
                    'RINGKASAN METRIK',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textBorder,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Revenue Card Full Width
                  NeoCard(
                    backgroundColor: AppColors.mint,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TOTAL PENDAPATAN PLATFORM',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Formatters.formatCurrency(stats.totalRevenue),
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textBorder,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.textBorder, width: 2),
                          ),
                          child: const Icon(LucideIcons.coins, size: 24, color: AppColors.textBorder),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 2x2 Stats Grid
                  Row(
                    children: [
                      Expanded(
                        child: NeoStatCard(
                          label: 'TOTAL EVENT',
                          value: '${stats.totalEvents}',
                          icon: LucideIcons.calendar,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: NeoStatCard(
                          label: 'TOTAL ORDER',
                          value: '${stats.totalOrders}',
                          icon: LucideIcons.shoppingBag,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: NeoStatCard(
                          label: 'TIKET TERJUAL',
                          value: '${stats.totalTicketsSold}',
                          icon: LucideIcons.ticket,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: NeoStatCard(
                          label: 'KEHADIRAN GATE',
                          value: '${stats.totalAttendance}',
                          icon: LucideIcons.userCheck,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Quick Management Menu Cards
                  Text(
                    'MANAJEMEN SISTEM',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textBorder,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Manage Users Navigation Card
                  NeoCard(
                    backgroundColor: Colors.white,
                    onTap: () => context.push('/admin/users'),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.toska,
                            border: Border.all(color: AppColors.textBorder, width: 2),
                          ),
                          child: const Icon(LucideIcons.users, size: 20, color: AppColors.textBorder),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Kelola Pengguna & Role',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textBorder,
                                ),
                              ),
                              Text(
                                'Ubah hak akses Customer, Panitia, atau Admin',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(LucideIcons.chevronRight, color: AppColors.textBorder),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Monitor All Orders Navigation Card
                  NeoCard(
                    backgroundColor: Colors.white,
                    onTap: () => context.push('/admin/orders'),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.pink,
                            border: Border.all(color: AppColors.textBorder, width: 2),
                          ),
                          child: const Icon(LucideIcons.fileSpreadsheet, size: 20, color: AppColors.textBorder),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Monitor Semua Transaksi Order',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textBorder,
                                ),
                              ),
                              Text(
                                'Cek status pembayaran & detail tiket semua order',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(LucideIcons.chevronRight, color: AppColors.textBorder),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/neo_widgets.dart';
import '../providers/organizer_provider.dart';

class OrganizerDashboardScreen extends ConsumerWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizerState = ref.watch(organizerProvider);
    final checkInCount = ref.watch(checkInSessionCounterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NeoAppBar(
        title: 'DASHBOARD',
        subtitleTag: 'PANITIA',
      ),
      body: organizerState.isLoading
          ? const NeoLoadingIndicator(text: 'Memuat dashboard...')
          : organizerState.errorMessage != null
              ? NeoErrorState(
                  message: organizerState.errorMessage!,
                  onRetry: () => ref.read(organizerProvider.notifier).loadMyEvents(),
                )
              : organizerState.events.isEmpty
                  ? NeoEmptyState(
                      title: 'BELUM ADA EVENT',
                      message: 'Mulai buat event pertama Anda untuk menjual tiket & presensi.',
                      icon: LucideIcons.calendar,
                      actionText: 'BUAT EVENT SEKARANG',
                      onAction: () => context.push('/organizer/create-event'),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16),
                      child: ListView(
                        children: [
                          // Statistic Cards Grid
                          const Text(
                            'RINGKASAN OPERASIONAL',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textBorder,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            children: [
                              NeoStatCard(
                                value: organizerState.totalTicketsSold.toString(),
                                label: 'Total Tiket Terjual',
                                icon: LucideIcons.ticket,
                                backgroundColor: Colors.white,
                                valueColor: AppColors.textBorder,
                              ),
                              NeoStatCard(
                                value: Formatters.formatCurrency(
                                    organizerState.totalEstimatedRevenue),
                                label: 'Estimasi Pendapatan',
                                icon: LucideIcons.dollarSign,
                                backgroundColor: Colors.white,
                                valueColor: AppColors.textBorder,
                              ),
                              NeoStatCard(
                                value: checkInCount.toString(),
                                label: 'Check-in Hari Ini',
                                icon: LucideIcons.checkCircle,
                                backgroundColor: Colors.white,
                                valueColor: AppColors.textBorder,
                              ),
                              NeoStatCard(
                                value: organizerState.activeEventsCount.toString(),
                                label: 'Jumlah Event Aktif',
                                icon: LucideIcons.activity,
                                backgroundColor: Colors.white,
                                valueColor: AppColors.textBorder,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Focus Event Card
                          const Text(
                            'EVENT TERDEKAT / SEDANG BERJALAN',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textBorder,
                            ),
                          ),
                          const SizedBox(height: 12),
                          NeoCard(
                            backgroundColor: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    NeoBadge(
                                      label: organizerState.focusEvent!.category,
                                      backgroundColor: AppColors.yellow,
                                      textColor: AppColors.textBorder,
                                      hasBorder: true,
                                    ),
                                    NeoBadge(
                                      label: organizerState.focusEvent!.status.toUpperCase(),
                                      backgroundColor:
                                          organizerState.focusEvent!.isPublished
                                              ? AppColors.mint
                                              : AppColors.orange,
                                      textColor: AppColors.textBorder,
                                      hasBorder: true,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  organizerState.focusEvent!.title,
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textBorder,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                        LucideIcons.calendar,
                                        size: 14,
                                        color: AppColors.textSecondary),
                                    const SizedBox(width: 6),
                                    Text(
                                      Formatters.formatDateTime(
                                          organizerState.focusEvent!.startTime!),
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textBorder,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                        LucideIcons.mapPin,
                                        size: 14,
                                        color: AppColors.textSecondary),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        organizerState.focusEvent!.venueName,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Divider(
                                    color: AppColors.divider, thickness: 1),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: NeoOutlineButton(
                                        text: 'EDIT EVENT',
                                        icon: LucideIcons.edit,
                                        backgroundColor: Colors.white,
                                        height: 36,
                                        fontSize: 10,
                                        onPressed: () => context.push(
                                            '/organizer/edit-event/${organizerState.focusEvent!.id}',
                                            extra: organizerState.focusEvent),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: NeoButton(
                                        text: 'BUKA SCANNER',
                                        icon: LucideIcons.scanLine,
                                        backgroundColor: AppColors.mint,
                                        height: 36,
                                        fontSize: 10,
                                        onPressed: () =>
                                            context.push('/scanner'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
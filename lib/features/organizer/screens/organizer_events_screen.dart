import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../providers/organizer_provider.dart';

class OrganizerEventsScreen extends ConsumerStatefulWidget {
  const OrganizerEventsScreen({super.key});

  @override
  ConsumerState<OrganizerEventsScreen> createState() => _OrganizerEventsScreenState();
}

class _OrganizerEventsScreenState extends ConsumerState<OrganizerEventsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(organizerProvider.notifier).loadMyEvents();
    });
  }

  void _confirmDeleteEvent(int eventId, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: AppColors.textBorder, width: 3),
        ),
        title: Row(
          children: [
            const Icon(LucideIcons.alertTriangle, color: AppColors.textBorder),
            const SizedBox(width: 8),
            Text(
              'HAPUS EVENT',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.textBorder,
              ),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus event "$title"? Tindakan ini tidak dapat dibatalkan.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppColors.textBorder,
          ),
        ),
        actions: [
          NeoOutlineButton(
            text: 'BATAL',
            onPressed: () => Navigator.pop(ctx),
          ),
          NeoButton(
            text: 'HAPUS',
            backgroundColor: AppColors.pink,
            height: 38,
            fontSize: 11,
            fullWidth: false,
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref.read(organizerProvider.notifier).deleteEvent(eventId);
              if (mounted) {
                if (success) {
                  showNeoSnackBar(context, 'Event berhasil dihapus', isSuccess: true);
                } else {
                  showNeoSnackBar(context, 'Gagal menghapus event', isError: true);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(organizerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'PANITIA EVENT',
        actions: [
          NeoIconButton(
            icon: LucideIcons.refreshCw,
            backgroundColor: AppColors.mint,
            size: 38,
            iconSize: 18,
            onPressed: () => ref.read(organizerProvider.notifier).loadMyEvents(),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.textBorder,
        backgroundColor: AppColors.yellow,
        onRefresh: () async {
          await ref.read(organizerProvider.notifier).loadMyEvents();
        },
        child: Column(
          children: [
            // Top Action Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: NeoCard(
                backgroundColor: AppColors.yellow,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'KELOLA EVENT SAYA',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textBorder,
                            ),
                          ),
                          Text(
                            'Total ${state.events.length} event terdaftar',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    NeoButton(
                      text: '+ BUAT EVENT',
                      backgroundColor: AppColors.mint,
                      height: 38,
                      fontSize: 11,
                      fullWidth: false,
                      onPressed: () => context.push('/organizer/create-event'),
                    ),
                  ],
                ),
              ),
            ),

            // Events List
            Expanded(
              child: state.isLoading
                  ? const NeoLoadingIndicator(text: 'Memuat daftar event Anda...')
                  : state.errorMessage != null
                      ? NeoErrorState(
                          message: state.errorMessage!,
                          onRetry: () => ref.read(organizerProvider.notifier).loadMyEvents(),
                        )
                      : state.events.isEmpty
                          ? NeoEmptyState(
                              title: 'BELUM ADA EVENT',
                              message: 'Mulai buat event pertama Anda untuk menjual tiket & presensi.',
                              actionText: 'BUAT EVENT SEKARANG',
                              onAction: () => context.push('/organizer/create-event'),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                              itemCount: state.events.length,
                              itemBuilder: (context, index) {
                                final event = state.events[index];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: AppColors.textBorder, width: 2.5),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: AppColors.textBorder,
                                        offset: Offset(4, 4),
                                        blurRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            NeoBadge(
                                              label: event.category,
                                              backgroundColor: AppColors.yellow,
                                              textColor: AppColors.textBorder,
                                              hasBorder: true,
                                            ),
                                            NeoBadge(
                                              label: event.status.toUpperCase(),
                                              backgroundColor: event.isPublished ? AppColors.mint : AppColors.orange,
                                              textColor: AppColors.textBorder,
                                              hasBorder: true,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          event.title,
                                          style: GoogleFonts.spaceGrotesk(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.textBorder,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(LucideIcons.calendar, size: 14, color: AppColors.textSecondary),
                                            const SizedBox(width: 6),
                                            Text(
                                              Formatters.formatDateTime(event.startTime),
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
                                            const Icon(LucideIcons.mapPin, size: 14, color: AppColors.textSecondary),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                event.venueName,
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
                                        const SizedBox(height: 12),
                                        const Divider(color: AppColors.divider, thickness: 1),
                                        const SizedBox(height: 8),

                                        // Actions Row
                                        Wrap(
                                          spacing: 6,
                                          runSpacing: 6,
                                          children: [
                                            NeoButton(
                                              text: 'TIER TIKET (${event.ticketTiers.length})',
                                              icon: LucideIcons.layers,
                                              backgroundColor: AppColors.toska,
                                              height: 32,
                                              fontSize: 10,
                                              fullWidth: false,
                                              onPressed: () {
                                                context.push('/organizer/events/${event.id}/tiers', extra: event);
                                              },
                                            ),
                                            NeoOutlineButton(
                                              text: 'EDIT',
                                              icon: LucideIcons.edit,
                                              backgroundColor: Colors.white,
                                              height: 32,
                                              fontSize: 10,
                                              onPressed: () {
                                                context.push('/organizer/edit-event/${event.id}', extra: event);
                                              },
                                            ),
                                            NeoIconButton(
                                              icon: LucideIcons.trash2,
                                              backgroundColor: AppColors.pink,
                                              size: 32,
                                              iconSize: 14,
                                              tooltip: 'Hapus Event',
                                              onPressed: () => _confirmDeleteEvent(event.id, event.title),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

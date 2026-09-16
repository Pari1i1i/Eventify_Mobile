import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../models/ticket_model.dart';
import '../providers/tickets_provider.dart';
import '../../events/providers/events_provider.dart';

class TicketDetailScreen extends ConsumerWidget {
  final String ticketCode;
  final TicketModel? initialTicket;

  const TicketDetailScreen({
    super.key,
    required this.ticketCode,
    this.initialTicket,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (initialTicket != null) {
      return _TicketDetailView(ticket: initialTicket!);
    }

    final ticketAsync = ref.watch(ticketDetailProvider(ticketCode));

    return ticketAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.background,
        appBar: NeoAppBar(title: 'EVENTIFY', subtitleTag: 'E-TIKET', showBackButton: true),
        body: NeoLoadingIndicator(text: 'Memuat e-tiket...'),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: const NeoAppBar(title: 'EVENTIFY', subtitleTag: 'E-TIKET', showBackButton: true),
        body: NeoErrorState(
          message: err.toString(),
          onRetry: () => ref.refresh(ticketDetailProvider(ticketCode)),
        ),
      ),
      data: (ticket) => _TicketDetailView(ticket: ticket),
    );
  }
}

class _TicketDetailView extends ConsumerWidget {
  final TicketModel ticket;

  const _TicketDetailView({required this.ticket});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isValid = ticket.isValid;

    final events = ref.watch(eventsProvider).events;
    final matchedEvent = events.where((e) => (ticket.eventId > 0 && e.id == ticket.eventId) || (ticket.eventTitle != null && e.title.toLowerCase() == ticket.eventTitle!.toLowerCase())).firstOrNull;

    final displayDate = ticket.eventDate ?? matchedEvent?.startTime;
    final displayVenue = (ticket.venueName != null && ticket.venueName != 'Venue' && ticket.venueName!.isNotEmpty)
        ? ticket.venueName!
        : (matchedEvent?.venueName ?? 'Venue');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'E-TIKET RESMI',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            // Concert Ticket Pass Container
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.textBorder, width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.textBorder,
                    offset: Offset(5, 5),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Upper Ticket Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isValid ? AppColors.yellow : (ticket.isExpired ? const Color(0x50FF4365) : Colors.grey.shade300),
                      border: const Border(bottom: BorderSide(color: AppColors.textBorder, width: 2.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.textBorder,
                                border: Border.all(color: AppColors.textBorder, width: 1.5),
                              ),
                              child: Text(
                                'OFFICIAL E-TICKET',
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            NeoBadge(
                              label: isValid
                                  ? 'STATUS: VALID'
                                  : (ticket.isUsed
                                      ? 'SUDAH SCAN'
                                      : (ticket.isExpired ? 'STATUS: HANGUS' : 'STATUS: BATAL')),
                              backgroundColor: isValid
                                  ? AppColors.mint
                                  : (ticket.isUsed ? AppColors.orange : AppColors.pink),
                              textColor: AppColors.textBorder,
                              hasBorder: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ticket.eventTitle ?? 'Eventify Live Experience',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textBorder,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Middle QR Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.textBorder, width: 2.5),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.textBorder,
                                offset: Offset(3, 3),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: QrImageView(
                            data: ticket.ticketCode,
                            version: QrVersions.auto,
                            size: 200.0,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: AppColors.textBorder,
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: AppColors.textBorder,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.toska,
                            border: Border.all(color: AppColors.textBorder, width: 1.5),
                          ),
                          child: Text(
                            ticket.ticketCode,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textBorder,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isValid
                              ? 'Tunjukkan QR ini kepada petugas di pintu masuk / gate event'
                              : (ticket.isExpired
                                  ? 'Tiket ini telah hangus karena event telah selesai (melewati D-DAY)'
                                  : (ticket.isUsed
                                      ? 'Tiket ini telah berhasil digunakan untuk check-in'
                                      : 'Tiket tidak dapat digunakan')),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: ticket.isExpired ? AppColors.pink : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Perforated Cutout Separator Line
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
                          border: Border(
                            top: BorderSide(color: AppColors.textBorder, width: 3),
                            right: BorderSide(color: AppColors.textBorder, width: 3),
                            bottom: BorderSide(color: AppColors.textBorder, width: 3),
                          ),
                        ),
                      ),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Flex(
                              direction: Axis.horizontal,
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                (constraints.constrainWidth() / 10).floor(),
                                (_) => const SizedBox(
                                  width: 5,
                                  height: 2,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(color: AppColors.textBorder),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 16,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
                          border: Border(
                            top: BorderSide(color: AppColors.textBorder, width: 3),
                            left: BorderSide(color: AppColors.textBorder, width: 3),
                            bottom: BorderSide(color: AppColors.textBorder, width: 3),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Bottom Ticket Information
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PEMEGANG TIKET',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    ticket.attendeeName,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textBorder,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TIER TIKET',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    ticket.tierName?.toUpperCase() ?? 'REGULER',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textBorder,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(color: AppColors.divider, thickness: 1),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TANGGAL EVENT',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    Formatters.formatDateTime(displayDate),
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBorder,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'LOKASI VENUE',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    displayVenue,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textBorder,
                                    ),
                                  ),
                                ],
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

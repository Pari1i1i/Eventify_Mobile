import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/ticket_model.dart';
import '../providers/tickets_provider.dart';

class MyTicketsScreen extends ConsumerStatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  ConsumerState<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends ConsumerState<MyTicketsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ticketsProvider.notifier).loadTickets();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildTicketCard(TicketModel ticket) {
    final isValid = ticket.isValid;

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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push('/tickets/${ticket.ticketCode}', extra: ticket);
          },
          child: Column(
            children: [
              // Upper Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isValid ? AppColors.yellow : Colors.grey.shade200,
                  border: const Border(bottom: BorderSide(color: AppColors.textBorder, width: 2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(LucideIcons.ticket, size: 16, color: AppColors.textBorder),
                        const SizedBox(width: 8),
                        Text(
                          ticket.ticketCode,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textBorder,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    NeoBadge(
                      label: isValid ? 'VALID' : (ticket.isUsed ? 'SUDAH SCAN' : 'BATAL'),
                      backgroundColor: isValid ? AppColors.mint : (ticket.isUsed ? AppColors.orange : AppColors.pink),
                      textColor: AppColors.textBorder,
                      hasBorder: true,
                    ),
                  ],
                ),
              ),

              // Main body
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.eventTitle ?? 'Event',
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.purpleLight,
                            border: Border.all(color: AppColors.textBorder, width: 1.5),
                          ),
                          child: Text(
                            ticket.tierName?.toUpperCase() ?? 'REGULER',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textBorder,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(LucideIcons.user, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            ticket.attendeeName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textBorder,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: AppColors.divider, thickness: 1),
                    const SizedBox(height: 6),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(LucideIcons.calendar, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              Formatters.formatDate(ticket.eventDate),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        NeoButton(
                          text: 'BUKA QR',
                          icon: LucideIcons.qrCode,
                          backgroundColor: isValid ? AppColors.mint : AppColors.yellow,
                          height: 32,
                          fontSize: 10,
                          fullWidth: false,
                          onPressed: () {
                            context.push('/tickets/${ticket.ticketCode}', extra: ticket);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final ticketsState = ref.watch(ticketsProvider);

    if (!authState.isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const NeoAppBar(title: 'EVENTIFY', subtitleTag: 'TIKET SAYA'),
        body: NeoEmptyState(
          title: 'BELUM MASUK AKUN',
          message: 'Silakan masuk akun untuk melihat dan membuka tiket event Anda.',
          actionText: 'MASUK SEKARANG',
          onAction: () => context.push('/login'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'TIKET SAYA',
        actions: [
          NeoIconButton(
            icon: LucideIcons.refreshCw,
            backgroundColor: AppColors.mint,
            size: 38,
            iconSize: 18,
            onPressed: () => ref.read(ticketsProvider.notifier).loadTickets(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Offline Banner Indicator
          if (ticketsState.isOffline)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.orange,
              child: Row(
                children: [
                  const Icon(LucideIcons.wifiOff, size: 16, color: AppColors.textBorder),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Mode Offline: Tiket tersimpan dapat discan langsung di gate.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBorder,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Custom Neobrutalism Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: AppColors.textBorder, width: 2),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.textBorder,
              unselectedLabelColor: AppColors.textSecondary,
              indicator: const BoxDecoration(
                color: AppColors.yellow,
                border: Border(
                  bottom: BorderSide(color: AppColors.textBorder, width: 3),
                ),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w900, fontSize: 12),
              unselectedLabelStyle: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700, fontSize: 12),
              tabs: [
                Tab(text: 'TIKET AKTIF (${ticketsState.activeTickets.length})'),
                Tab(text: 'RIWAYAT (${ticketsState.usedTickets.length})'),
              ],
            ),
          ),

          // Tab views
          Expanded(
            child: RefreshIndicator(
              color: AppColors.textBorder,
              backgroundColor: AppColors.yellow,
              onRefresh: () async {
                await ref.read(ticketsProvider.notifier).loadTickets();
              },
              child: ticketsState.isLoading
                  ? const NeoLoadingIndicator(text: 'Memuat tiket Anda...')
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        // Active Tickets Tab
                        ticketsState.activeTickets.isEmpty
                            ? NeoEmptyState(
                                title: 'TIDAK ADA TIKET AKTIF',
                                message: 'Anda belum memiliki tiket aktif yang belum digunakan.',
                                actionText: 'CARI EVENT',
                                onAction: () => context.go('/home'),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                itemCount: ticketsState.activeTickets.length,
                                itemBuilder: (context, index) {
                                  return _buildTicketCard(ticketsState.activeTickets[index]);
                                },
                              ),

                        // Used / Past Tickets Tab
                        ticketsState.usedTickets.isEmpty
                            ? const NeoEmptyState(
                                title: 'BELUM ADA RIWAYAT TIKET',
                                message: 'Tiket yang telah digunakan atau kadaluarsa akan muncul di sini.',
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                itemCount: ticketsState.usedTickets.length,
                                itemBuilder: (context, index) {
                                  return _buildTicketCard(ticketsState.usedTickets[index]);
                                },
                              ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

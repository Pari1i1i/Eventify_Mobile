import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../../../user/widgets/event_banner_painters.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/event_model.dart';
import '../models/ticket_tier_model.dart';
import '../providers/events_provider.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final String slug;
  final EventModel? initialEvent;

  const EventDetailScreen({super.key, required this.slug, this.initialEvent});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  // Map of selected tier quantities: {tierId: quantity}
  final Map<int, int> _selectedQuantities = {};

  Widget _buildBanner(EventModel event) {
    if (event.bannerUrl != null && event.bannerUrl!.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: event.bannerUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 200,
          color: AppColors.purpleLight,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2.5, color: AppColors.textBorder)),
        ),
        errorWidget: (context, url, error) => _buildFallbackBanner(event),
      );
    }
    return _buildFallbackBanner(event);
  }

  Widget _buildFallbackBanner(EventModel event) {
    final titleLower = event.title.toLowerCase();
    if (titleLower.contains('run') || titleLower.contains('marathon')) {
      return SizedBox(
        height: 200,
        width: double.infinity,
        child: CustomPaint(painter: FunRunBannerPainter()),
      );
    } else if (titleLower.contains('bike') || titleLower.contains('sepeda')) {
      return SizedBox(
        height: 200,
        width: double.infinity,
        child: CustomPaint(painter: PushbikeBannerPainter()),
      );
    } else if (titleLower.contains('tech') || titleLower.contains('ai')) {
      return SizedBox(
        height: 200,
        width: double.infinity,
        child: CustomPaint(painter: TechExpoBannerPainter()),
      );
    }
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: CustomPaint(
        painter: GenericBannerPainter(
          title: event.title,
          bgColor: AppColors.purpleSeed,
        ),
      ),
    );
  }

  int get _totalSelectedTickets {
    return _selectedQuantities.values.fold(0, (sum, q) => sum + q);
  }

  num _calculateTotalPrice(List<TicketTierModel> tiers) {
    num total = 0;
    for (var tier in tiers) {
      final qty = _selectedQuantities[tier.id] ?? 0;
      total += tier.price * qty;
    }
    return total;
  }

  void _proceedToCheckout(EventModel event) {
    if (_totalSelectedTickets == 0) {
      showNeoSnackBar(context, 'Pilih minimal 1 tiket untuk melanjutkan checkout', isError: true);
      return;
    }

    final authState = ref.read(authStateProvider);
    if (!authState.isAuthenticated) {
      showNeoSnackBar(context, 'Silakan masuk akun terlebih dahulu sebelum checkout');
      context.push('/login');
      return;
    }

    // Build checkout payload
    final selectedTiers = event.ticketTiers.where((t) => (_selectedQuantities[t.id] ?? 0) > 0).map((t) {
      return {
        'tier': t,
        'quantity': _selectedQuantities[t.id]!,
      };
    }).toList();

    context.push(
      '/checkout',
      extra: {
        'event': event,
        'selectedTiers': selectedTiers,
        'totalAmount': _calculateTotalPrice(event.ticketTiers),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventDetailProvider(widget.slug));
    final event = eventAsync.valueOrNull ?? widget.initialEvent;

    if (event == null) {
      if (eventAsync.isLoading) {
        return const Scaffold(
          backgroundColor: AppColors.background,
          appBar: NeoAppBar(title: 'EVENTIFY', subtitleTag: 'DETAIL EVENT', showBackButton: true),
          body: NeoLoadingIndicator(text: 'Memuat informasi event...'),
        );
      }
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: const NeoAppBar(title: 'EVENTIFY', subtitleTag: 'DETAIL EVENT', showBackButton: true),
        body: NeoErrorState(
          message: eventAsync.error?.toString() ?? 'Gagal memuat event',
          onRetry: () => ref.refresh(eventDetailProvider(widget.slug)),
        ),
      );
    }

    final totalPrice = _calculateTotalPrice(event.ticketTiers);
    final totalQty = _totalSelectedTickets;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NeoAppBar(
        title: 'EVENTIFY',
        subtitleTag: 'DETAIL EVENT',
        showBackButton: true,
        actions: [
          NeoIconButton(
            icon: LucideIcons.share2,
            backgroundColor: AppColors.yellow,
            size: 38,
            iconSize: 18,
            onPressed: () {
              showNeoSnackBar(context, 'Tautan event disalin ke clipboard!', isSuccess: true);
            },
          ),
        ],
      ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Card
                NeoCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          _buildBanner(event),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: NeoBadge(
                              label: event.category,
                              backgroundColor: AppColors.yellow,
                              textColor: AppColors.textBorder,
                              hasBorder: true,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: NeoBadge(
                              label: event.status.toUpperCase(),
                              backgroundColor: event.isPublished ? AppColors.mint : AppColors.orange,
                              textColor: AppColors.textBorder,
                              hasBorder: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Title & Info
                NeoCard(
                  backgroundColor: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textBorder,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (event.organizerName != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(LucideIcons.userCheck, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              'Diselenggarakan oleh: ${event.organizerName}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 14),
                      const Divider(color: AppColors.divider, thickness: 1.5),
                      const SizedBox(height: 12),

                      // Date and Time
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.orange,
                              border: Border.all(color: AppColors.textBorder, width: 1.5),
                            ),
                            child: const Icon(LucideIcons.calendar, size: 16, color: AppColors.textBorder),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'WAKTU PELAKSANAAN',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textSecondary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  Formatters.formatDateTime(event.startTime),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textBorder,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Location & Venue
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.toska,
                              border: Border.all(color: AppColors.textBorder, width: 1.5),
                            ),
                            child: const Icon(LucideIcons.mapPin, size: 16, color: AppColors.textBorder),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'LOKASI VENUE',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textSecondary,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  event.venueName,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textBorder,
                                  ),
                                ),
                                if (event.venueAddress != null && event.venueAddress!.isNotEmpty)
                                  Text(
                                    event.venueAddress!,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
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

                const SizedBox(height: 16),

                // Description
                NeoCard(
                  backgroundColor: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DESKRIPSI EVENT',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textBorder,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description.isNotEmpty ? event.description : 'Tidak ada deskripsi rinci untuk event ini.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          height: 1.5,
                          color: AppColors.textBorder,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Ticket Tiers Header
                Text(
                  'PILIHAN TIKET (${event.ticketTiers.length})',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textBorder,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 10),

                // Ticket Tiers List
                if (event.ticketTiers.isEmpty)
                  NeoCard(
                    backgroundColor: AppColors.yellow,
                    child: Center(
                      child: Text(
                        'Tiket belum dibuka untuk event ini.',
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: AppColors.textBorder,
                        ),
                      ),
                    ),
                  )
                else
                  ...event.ticketTiers.map((tier) {
                    final qty = _selectedQuantities[tier.id] ?? 0;
                    final isSoldOut = tier.isSoldOut;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: qty > 0 ? AppColors.yellow.withValues(alpha: 0.2) : Colors.white,
                        border: Border.all(
                          color: qty > 0 ? AppColors.textBorder : AppColors.textBorder,
                          width: qty > 0 ? 3.0 : 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textBorder,
                            offset: qty > 0 ? const Offset(4, 4) : const Offset(2.5, 2.5),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        tier.name,
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.textBorder,
                                        ),
                                      ),
                                      if (tier.description != null && tier.description!.isNotEmpty)
                                        Text(
                                          tier.description!,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                NeoBadge(
                                  label: isSoldOut ? 'HABIS' : 'SISA ${tier.remainingQuota}',
                                  backgroundColor: isSoldOut ? AppColors.pink : AppColors.mint,
                                  textColor: AppColors.textBorder,
                                  hasBorder: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Divider(color: AppColors.divider, thickness: 1),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Formatters.formatCurrency(tier.price),
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: tier.price == 0 ? AppColors.purpleSeed : AppColors.magenta,
                                  ),
                                ),
                                if (isSoldOut)
                                  Text(
                                    'SOLD OUT',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.red,
                                    ),
                                  )
                                else
                                  Row(
                                    children: [
                                      NeoIconButton(
                                        icon: LucideIcons.minus,
                                        size: 32,
                                        iconSize: 14,
                                        backgroundColor: qty > 0 ? AppColors.pink : Colors.grey.shade300,
                                        onPressed: qty > 0
                                            ? () {
                                                setState(() {
                                                  _selectedQuantities[tier.id] = qty - 1;
                                                });
                                              }
                                            : null,
                                      ),
                                      Container(
                                        width: 38,
                                        alignment: Alignment.center,
                                        child: Text(
                                          '$qty',
                                          style: GoogleFonts.spaceGrotesk(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.textBorder,
                                          ),
                                        ),
                                      ),
                                      NeoIconButton(
                                        icon: LucideIcons.plus,
                                        size: 32,
                                        iconSize: 14,
                                        backgroundColor: qty < tier.remainingQuota ? AppColors.mint : Colors.grey.shade300,
                                        onPressed: qty < tier.remainingQuota && qty < 10
                                            ? () {
                                                setState(() {
                                                  _selectedQuantities[tier.id] = qty + 1;
                                                });
                                              }
                                            : null,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(
                top: BorderSide(color: AppColors.textBorder, width: 3),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textBorder.withValues(alpha: 0.1),
                  offset: const Offset(0, -4),
                  blurRadius: 0,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$totalQty TIKET DIPILIH',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          Formatters.formatCurrency(totalPrice),
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: totalPrice == 0 ? AppColors.purpleSeed : AppColors.magenta,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  NeoButton(
                    text: 'BELI TIKET',
                    icon: LucideIcons.shoppingBag,
                    backgroundColor: totalQty > 0 ? AppColors.yellow : Colors.grey.shade300,
                    height: 46,
                    fontSize: 12,
                    fullWidth: false,
                    onPressed: totalQty > 0 ? () => _proceedToCheckout(event) : null,
                  ),
                ],
              ),
            ),
          ),
        );
  }
}

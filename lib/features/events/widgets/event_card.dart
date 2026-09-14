import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/neo_widgets.dart';
import '../models/event_model.dart';
import '../../../user/widgets/event_banner_painters.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  Widget _buildBanner(BuildContext context) {
    if (event.bannerUrl != null && event.bannerUrl!.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: event.bannerUrl!,
        height: 140,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 140,
          color: AppColors.purpleLight,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textBorder),
          ),
        ),
        errorWidget: (context, url, error) => _buildFallbackBanner(),
      );
    }
    return _buildFallbackBanner();
  }

  Widget _buildFallbackBanner() {
    final titleLower = event.title.toLowerCase();
    if (titleLower.contains('run') || titleLower.contains('marathon')) {
      return SizedBox(
        height: 140,
        width: double.infinity,
        child: CustomPaint(painter: FunRunBannerPainter()),
      );
    } else if (titleLower.contains('bike') || titleLower.contains('sepeda') || titleLower.contains('race')) {
      return SizedBox(
        height: 140,
        width: double.infinity,
        child: CustomPaint(painter: PushbikeBannerPainter()),
      );
    } else if (titleLower.contains('tech') || titleLower.contains('ai') || titleLower.contains('expo')) {
      return SizedBox(
        height: 140,
        width: double.infinity,
        child: CustomPaint(painter: TechExpoBannerPainter()),
      );
    }
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: CustomPaint(
        painter: GenericBannerPainter(
          title: event.title,
          bgColor: AppColors.purpleSeed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner with category badge
              Stack(
                children: [
                  _buildBanner(context),
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
                  if (event.organizerName != null && event.organizerName!.isNotEmpty)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.textBorder,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(LucideIcons.user, size: 10, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              event.organizerName!,
                              style: GoogleFonts.spaceGrotesk(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              const Divider(color: AppColors.textBorder, thickness: 2, height: 2),

              // Event Information
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textBorder,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // Date row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.orange,
                            border: Border.all(color: AppColors.textBorder, width: 1.5),
                          ),
                          child: const Icon(LucideIcons.calendar, size: 14, color: AppColors.textBorder),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            Formatters.formatDateTime(event.startTime),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textBorder,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Location row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.toska,
                            border: Border.all(color: AppColors.textBorder, width: 1.5),
                          ),
                          child: const Icon(LucideIcons.mapPin, size: 14, color: AppColors.textBorder),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            event.city != null && event.city!.isNotEmpty
                                ? '${event.venueName}, ${event.city}'
                                : event.venueName,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBorder,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    const Divider(color: AppColors.divider, thickness: 1.5),
                    const SizedBox(height: 10),

                    // Price & CTA Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MULAI DARI',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textSecondary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              Formatters.formatCurrency(event.startingPrice),
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: event.startingPrice == 0 ? AppColors.purpleSeed : AppColors.magenta,
                              ),
                            ),
                          ],
                        ),
                        NeoButton(
                          text: 'DETAIL EVENT',
                          icon: LucideIcons.arrowRight,
                          backgroundColor: AppColors.yellow,
                          height: 36,
                          fontSize: 11,
                          fullWidth: false,
                          onPressed: onTap,
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
}

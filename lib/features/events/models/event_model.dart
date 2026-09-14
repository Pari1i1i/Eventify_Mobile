import 'ticket_tier_model.dart';

class EventModel {
  final int id;
  final String title;
  final String slug;
  final String description;
  final String category;
  final String? bannerUrl;
  final String venueName;
  final String? venueAddress;
  final String? city;
  final DateTime? startTime;
  final DateTime? endTime;
  final String status; // 'published', 'draft', 'ended'
  final int? organizerId;
  final String? organizerName;
  final List<TicketTierModel> ticketTiers;
  final num? minPrice;

  EventModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.description,
    required this.category,
    this.bannerUrl,
    required this.venueName,
    this.venueAddress,
    this.city,
    this.startTime,
    this.endTime,
    this.status = 'published',
    this.organizerId,
    this.organizerName,
    this.ticketTiers = const [],
    this.minPrice,
  });

  bool get isPublished => status.toLowerCase() == 'published';

  num get startingPrice {
    if (minPrice != null && minPrice! > 0) return minPrice!;
    if (ticketTiers.isEmpty) return 0;
    num lowest = ticketTiers.first.price;
    for (var tier in ticketTiers) {
      if (tier.price < lowest) lowest = tier.price;
    }
    return lowest;
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    List<TicketTierModel> tiers = [];
    if (json['ticket_tiers'] is List) {
      tiers = (json['ticket_tiers'] as List)
          .map((e) => TicketTierModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (json['tiers'] is List) {
      tiers = (json['tiers'] as List)
          .map((e) => TicketTierModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    final title = json['name']?.toString() ?? json['title']?.toString() ?? json['judul']?.toString() ?? 'Event Tanpa Judul';
    final location = json['location']?.toString() ?? json['venue_name']?.toString() ?? json['lokasi']?.toString() ?? 'Venue';
    final startAt = json['start_at'] != null
        ? DateTime.tryParse(json['start_at'].toString())
        : json['start_time'] != null
            ? DateTime.tryParse(json['start_time'].toString())
            : json['waktu'] != null
                ? DateTime.tryParse(json['waktu'].toString())
                : null;
    final endAt = json['end_at'] != null
        ? DateTime.tryParse(json['end_at'].toString())
        : json['end_time'] != null
            ? DateTime.tryParse(json['end_time'].toString())
            : null;

    return EventModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: title,
      slug: json['slug']?.toString() ?? json['id']?.toString() ?? '',
      description: json['description']?.toString() ?? json['deskripsi']?.toString() ?? '',
      category: json['category']?.toString() ?? json['kategori']?.toString() ?? 'Event',
      bannerUrl: json['banner_url']?.toString() ?? json['banner_path']?.toString() ?? json['banner']?.toString(),
      venueName: location,
      venueAddress: json['venue_address']?.toString() ?? json['alamat']?.toString(),
      city: json['city']?.toString() ?? json['kota']?.toString(),
      startTime: startAt,
      endTime: endAt,
      status: json['status']?.toString() ?? 'published',
      organizerId: json['created_by'] is int
          ? json['created_by']
          : json['organizer_id'] is int
              ? json['organizer_id']
              : int.tryParse(json['created_by']?.toString() ?? json['organizer_id']?.toString() ?? '0'),
      organizerName: json['creator_name']?.toString() ?? json['organizer_name']?.toString() ?? json['organizer']?['name']?.toString(),
      ticketTiers: tiers,
      minPrice: json['min_price'] is num ? json['min_price'] : num.tryParse(json['min_price']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'title': title,
      'slug': slug,
      'description': description,
      'category': category,
      'banner_url': bannerUrl,
      'location': venueName,
      'venue_name': venueName,
      'venue_address': venueAddress,
      'city': city,
      'start_at': startTime?.toIso8601String(),
      'end_at': endTime?.toIso8601String(),
      'status': status,
      'created_by': organizerId,
      'creator_name': organizerName,
      'ticket_tiers': ticketTiers.map((t) => t.toJson()).toList(),
      'min_price': minPrice,
    };
  }
}

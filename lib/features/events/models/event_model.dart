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

    return EventModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? json['judul']?.toString() ?? 'Event Tanpa Judul',
      slug: json['slug']?.toString() ?? json['id']?.toString() ?? '',
      description: json['description']?.toString() ?? json['deskripsi']?.toString() ?? '',
      category: json['category']?.toString() ?? json['kategori']?.toString() ?? 'Umum',
      bannerUrl: json['banner_url']?.toString() ?? json['banner']?.toString(),
      venueName: json['venue_name']?.toString() ?? json['lokasi']?.toString() ?? json['venue']?.toString() ?? 'Venue',
      venueAddress: json['venue_address']?.toString() ?? json['alamat']?.toString(),
      city: json['city']?.toString() ?? json['kota']?.toString(),
      startTime: json['start_time'] != null
          ? DateTime.tryParse(json['start_time'].toString())
          : json['waktu'] != null
              ? DateTime.tryParse(json['waktu'].toString())
              : null,
      endTime: json['end_time'] != null ? DateTime.tryParse(json['end_time'].toString()) : null,
      status: json['status']?.toString() ?? 'published',
      organizerId: json['organizer_id'] is int ? json['organizer_id'] : int.tryParse(json['organizer_id']?.toString() ?? '0'),
      organizerName: json['organizer_name']?.toString() ?? json['organizer']?['name']?.toString(),
      ticketTiers: tiers,
      minPrice: json['min_price'] is num ? json['min_price'] : num.tryParse(json['min_price']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'description': description,
      'category': category,
      'banner_url': bannerUrl,
      'venue_name': venueName,
      'venue_address': venueAddress,
      'city': city,
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'status': status,
      'organizer_id': organizerId,
      'organizer_name': organizerName,
      'ticket_tiers': ticketTiers.map((t) => t.toJson()).toList(),
      'min_price': minPrice,
    };
  }
}

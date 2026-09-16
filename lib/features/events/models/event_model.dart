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

    final resolvedCategory = _resolveCategory(
      json: json,
      title: title,
      description: json['description']?.toString() ?? json['deskripsi']?.toString() ?? '',
    );

    return EventModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: title,
      slug: json['slug']?.toString() ?? json['id']?.toString() ?? '',
      description: json['description']?.toString() ?? json['deskripsi']?.toString() ?? '',
      category: resolvedCategory,
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

  static String _resolveCategory({
    required Map<String, dynamic> json,
    required String title,
    required String description,
  }) {
    // 1. Direct field from API if exists and not generic 'Event'
    final rawCat = json['category']?.toString() ??
        json['kategori']?.toString() ??
        json['category_name']?.toString() ??
        json['type']?.toString();

    if (rawCat != null &&
        rawCat.trim().isNotEmpty &&
        rawCat.trim().toLowerCase() != 'event' &&
        rawCat.trim().toLowerCase() != 'null') {
      return _normalizeCategory(rawCat.trim());
    }

    // 2. Intelligent inference from title, slug, and description
    final combined = '$title $description ${json['slug'] ?? ''}'.toLowerCase();

    // Olahraga & Lari
    if (combined.contains('run') ||
        combined.contains('lari') ||
        combined.contains('marathon') ||
        combined.contains('fun run') ||
        combined.contains('sepeda') ||
        combined.contains('bike') ||
        combined.contains('sport') ||
        combined.contains('olahraga') ||
        combined.contains('futsal') ||
        combined.contains('badminton') ||
        combined.contains('gym')) {
      return 'Olahraga & Lari';
    }

    // Kompetisi Anak
    if (combined.contains('anak') ||
        combined.contains('kids') ||
        combined.contains('balita') ||
        combined.contains('pushbike') ||
        combined.contains('lomba anak') ||
        combined.contains('bocah')) {
      return 'Kompetisi Anak';
    }

    // Teknologi & AI
    if (combined.contains('ai') ||
        combined.contains('tech') ||
        combined.contains('teknologi') ||
        combined.contains('cloud') ||
        combined.contains('cyber') ||
        combined.contains('ctf') ||
        combined.contains('security') ||
        combined.contains('coding') ||
        combined.contains('developer') ||
        combined.contains('unreal') ||
        combined.contains('game dev') ||
        combined.contains('software') ||
        combined.contains('summit')) {
      return 'Teknologi & AI';
    }

    // Workshop & Seminar
    if (combined.contains('workshop') ||
        combined.contains('masterclass') ||
        combined.contains('bootcamp') ||
        combined.contains('ui/ux') ||
        combined.contains('design') ||
        combined.contains('pelatihan') ||
        combined.contains('seminar') ||
        combined.contains('training') ||
        combined.contains('kursus') ||
        combined.contains('kelas')) {
      return 'Workshop';
    }

    // Musik & Konser
    if (combined.contains('musik') ||
        combined.contains('music') ||
        combined.contains('konser') ||
        combined.contains('concert') ||
        combined.contains('soundwave') ||
        combined.contains('fest') ||
        combined.contains('festival') ||
        combined.contains('vivera') ||
        combined.contains('band') ||
        combined.contains('pensi') ||
        combined.contains('akustik') ||
        combined.contains('song')) {
      return 'Musik & Konser';
    }

    // 3. Fallback: Default to 'Musik & Konser' (matching admin platform default)
    return 'Musik & Konser';
  }

  static String _normalizeCategory(String cat) {
    final lower = cat.toLowerCase();
    if (lower.contains('musik') || lower.contains('music') || lower.contains('konser')) {
      return 'Musik & Konser';
    }
    if (lower.contains('tekno') || lower.contains('tech') || lower.contains('ai')) {
      return 'Teknologi & AI';
    }
    if (lower.contains('olah') || lower.contains('lari') || lower.contains('run') || lower.contains('sport')) {
      return 'Olahraga & Lari';
    }
    if (lower.contains('work') || lower.contains('seminar') || lower.contains('bootcamp') || lower.contains('class')) {
      return 'Workshop';
    }
    if (lower.contains('anak') || lower.contains('kids')) {
      return 'Kompetisi Anak';
    }
    return cat;
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

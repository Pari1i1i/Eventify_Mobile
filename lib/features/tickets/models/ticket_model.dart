class TicketModel {
  final int id;
  final String ticketCode;
  final int orderId;
  final int eventId;
  final int? tierId;
  final String? eventTitle;
  final String? eventBanner;
  final String? tierName;
  final String? venueName;
  final String? venueAddress;
  final DateTime? eventDate;
  final String attendeeName;
  final String? attendeeEmail;
  final String? attendeePhone;
  final String status; // 'valid', 'used', 'cancelled'
  final DateTime? checkedInAt;
  final DateTime? createdAt;

  TicketModel({
    required this.id,
    required this.ticketCode,
    required this.orderId,
    required this.eventId,
    this.tierId,
    this.eventTitle,
    this.eventBanner,
    this.tierName,
    this.venueName,
    this.venueAddress,
    this.eventDate,
    required this.attendeeName,
    this.attendeeEmail,
    this.attendeePhone,
    required this.status,
    this.checkedInAt,
    this.createdAt,
  });

  bool get isValid => status.toLowerCase() == 'valid' || status.toLowerCase() == 'active';
  bool get isUsed => status.toLowerCase() == 'used' || status.toLowerCase() == 'checked_in' || checkedInAt != null;
  bool get isCancelled => status.toLowerCase() == 'cancelled' || status.toLowerCase() == 'cancel';

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    final code = json['code']?.toString() ?? json['ticket_code']?.toString() ?? '';
    final eventTitle = json['event_name']?.toString() ?? json['event_title']?.toString() ?? json['event']?['title']?.toString() ?? json['event']?['name']?.toString() ?? 'Event Tiket';
    final tierName = json['ticket_tier_name']?.toString() ?? json['tier_name']?.toString() ?? json['ticket_tier']?['name']?.toString() ?? 'Reguler';
    final attendeeName = json['customer_name']?.toString() ?? json['attendee_name']?.toString() ?? 'Pengunjung';

    return TicketModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      ticketCode: code,
      orderId: json['order_id'] is int ? json['order_id'] : int.tryParse(json['order_id']?.toString() ?? '0') ?? 0,
      eventId: json['event_id'] is int ? json['event_id'] : int.tryParse(json['event_id']?.toString() ?? '0') ?? 0,
      tierId: json['tier_id'] is int
          ? json['tier_id']
          : json['ticket_tier_id'] is int
              ? json['ticket_tier_id']
              : int.tryParse(json['tier_id']?.toString() ?? json['ticket_tier_id']?.toString() ?? '0'),
      eventTitle: eventTitle,
      eventBanner: json['event_banner']?.toString() ?? json['event']?['banner_url']?.toString(),
      tierName: tierName,
      venueName: json['venue_name']?.toString() ?? json['location']?.toString() ?? json['event']?['location']?.toString() ?? json['event']?['venue_name']?.toString() ?? 'Venue',
      venueAddress: json['venue_address']?.toString() ?? json['event']?['venue_address']?.toString(),
      eventDate: json['event_date'] != null
          ? DateTime.tryParse(json['event_date'].toString())
          : json['start_at'] != null
              ? DateTime.tryParse(json['start_at'].toString())
              : json['event']?['start_time'] != null
                  ? DateTime.tryParse(json['event']['start_time'].toString())
                  : null,
      attendeeName: attendeeName,
      attendeeEmail: json['attendee_email']?.toString() ?? json['customer_email']?.toString(),
      attendeePhone: json['attendee_phone']?.toString(),
      status: json['status']?.toString().toLowerCase() ?? 'valid',
      checkedInAt: json['checked_in_at'] != null ? DateTime.tryParse(json['checked_in_at'].toString()) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': ticketCode,
      'ticket_code': ticketCode,
      'order_id': orderId,
      'event_id': eventId,
      'tier_id': tierId,
      'event_name': eventTitle,
      'event_title': eventTitle,
      'event_banner': eventBanner,
      'ticket_tier_name': tierName,
      'tier_name': tierName,
      'venue_name': venueName,
      'venue_address': venueAddress,
      'event_date': eventDate?.toIso8601String(),
      'customer_name': attendeeName,
      'attendee_name': attendeeName,
      'attendee_email': attendeeEmail,
      'attendee_phone': attendeePhone,
      'status': status,
      'checked_in_at': checkedInAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

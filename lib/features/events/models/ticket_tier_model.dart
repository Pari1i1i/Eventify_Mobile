class TicketTierModel {
  final int id;
  final int eventId;
  final String name;
  final String? description;
  final num price;
  final int quota;
  final int remainingQuota;
  final bool isAvailable;
  final DateTime? startSales;
  final DateTime? endSales;

  TicketTierModel({
    required this.id,
    required this.eventId,
    required this.name,
    this.description,
    required this.price,
    required this.quota,
    required this.remainingQuota,
    this.isAvailable = true,
    this.startSales,
    this.endSales,
  });

  bool get isSoldOut => remainingQuota <= 0 || !isAvailable;
  bool get isFree => price == 0;

  factory TicketTierModel.fromJson(Map<String, dynamic> json) {
    return TicketTierModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      eventId: json['event_id'] is int ? json['event_id'] : int.tryParse(json['event_id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? json['tier_name']?.toString() ?? 'Standard',
      description: json['description']?.toString(),
      price: json['price'] is num ? json['price'] : num.tryParse(json['price']?.toString() ?? '0') ?? 0,
      quota: json['quota'] is int ? json['quota'] : int.tryParse(json['quota']?.toString() ?? '0') ?? 0,
      remainingQuota: json['remaining_quota'] is int
          ? json['remaining_quota']
          : json['quota_left'] is int
              ? json['quota_left']
              : int.tryParse(json['remaining_quota']?.toString() ?? json['quota']?.toString() ?? '0') ?? 0,
      isAvailable: json['is_available'] is bool
          ? json['is_available']
          : json['is_active'] is bool
              ? json['is_active']
              : true,
      startSales: json['start_sale_at'] != null
          ? DateTime.tryParse(json['start_sale_at'].toString())
          : json['start_sales'] != null
              ? DateTime.tryParse(json['start_sales'].toString())
              : null,
      endSales: json['end_sale_at'] != null
          ? DateTime.tryParse(json['end_sale_at'].toString())
          : json['end_sales'] != null
              ? DateTime.tryParse(json['end_sales'].toString())
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event_id': eventId,
      'name': name,
      'description': description,
      'price': price,
      'quota': quota,
      'remaining_quota': remainingQuota,
      'is_available': isAvailable,
      'start_sale_at': startSales?.toIso8601String(),
      'end_sale_at': endSales?.toIso8601String(),
    };
  }
}

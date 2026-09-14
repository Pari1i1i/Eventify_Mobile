class OrderItemModel {
  final int id;
  final int orderId;
  final int tierId;
  final String tierName;
  final num price;
  final int quantity;
  final num subtotal;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.tierId,
    required this.tierName,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final price = json['price'] is num ? json['price'] : num.tryParse(json['price']?.toString() ?? '0') ?? 0;
    final qty = json['quantity'] is int ? json['quantity'] : int.tryParse(json['quantity']?.toString() ?? '1') ?? 1;
    final sub = json['subtotal'] is num
        ? json['subtotal']
        : num.tryParse(json['subtotal']?.toString() ?? '') ?? (price * qty);

    return OrderItemModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderId: json['order_id'] is int ? json['order_id'] : int.tryParse(json['order_id']?.toString() ?? '0') ?? 0,
      tierId: json['ticket_tier_id'] is int
          ? json['ticket_tier_id']
          : json['tier_id'] is int
              ? json['tier_id']
              : int.tryParse(json['ticket_tier_id']?.toString() ?? json['tier_id']?.toString() ?? '0') ?? 0,
      tierName: json['tier_name']?.toString() ?? json['ticket_tier']?['name']?.toString() ?? 'Tiket',
      price: price,
      quantity: qty,
      subtotal: sub,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'ticket_tier_id': tierId,
      'tier_name': tierName,
      'price': price,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}

class OrderModel {
  final int id;
  final String orderCode;
  final int userId;
  final int eventId;
  final String? eventTitle;
  final String? eventBanner;
  final num totalAmount;
  final String status; // 'pending', 'paid', 'cancelled', 'expired'
  final String? paymentMethod;
  final String? paymentUrl;
  final String? qrCodeUrl;
  final String? vaNumber;
  final DateTime? createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.orderCode,
    required this.userId,
    required this.eventId,
    this.eventTitle,
    this.eventBanner,
    required this.totalAmount,
    required this.status,
    this.paymentMethod,
    this.paymentUrl,
    this.qrCodeUrl,
    this.vaNumber,
    this.createdAt,
    this.items = const [],
  });

  bool get isPaid => status.toLowerCase() == 'paid';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
  bool get isExpired => status.toLowerCase() == 'expired';
  bool get isFree => totalAmount == 0;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<OrderItemModel> orderItems = [];
    if (json['items'] is List) {
      orderItems = (json['items'] as List)
          .map((e) => OrderItemModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } else if (json['order_items'] is List) {
      orderItems = (json['order_items'] as List)
          .map((e) => OrderItemModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    return OrderModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderCode: json['order_code']?.toString() ?? json['code']?.toString() ?? json['id']?.toString() ?? '',
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      eventId: json['event_id'] is int ? json['event_id'] : int.tryParse(json['event_id']?.toString() ?? '0') ?? 0,
      eventTitle: json['event_title']?.toString() ?? json['event']?['title']?.toString(),
      eventBanner: json['event_banner']?.toString() ?? json['event']?['banner_url']?.toString(),
      totalAmount: json['total_amount'] is num
          ? json['total_amount']
          : num.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString().toLowerCase() ?? 'pending',
      paymentMethod: json['payment_method']?.toString(),
      paymentUrl: json['payment_url']?.toString() ?? json['snap_redirect_url']?.toString(),
      qrCodeUrl: json['qr_code_url']?.toString() ?? json['qris_url']?.toString(),
      vaNumber: json['va_number']?.toString(),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      items: orderItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_code': orderCode,
      'user_id': userId,
      'event_id': eventId,
      'event_title': eventTitle,
      'event_banner': eventBanner,
      'total_amount': totalAmount,
      'status': status,
      'payment_method': paymentMethod,
      'payment_url': paymentUrl,
      'qr_code_url': qrCodeUrl,
      'va_number': vaNumber,
      'created_at': createdAt?.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

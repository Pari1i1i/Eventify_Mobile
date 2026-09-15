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
    final price = json['price'] is num
        ? json['price']
        : json['tier_price'] is num
            ? json['tier_price']
            : num.tryParse(json['price']?.toString() ?? json['tier_price']?.toString() ?? '0') ?? 0;
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
      tierName: json['tier_name']?.toString() ?? json['ticket_tier_name']?.toString() ?? json['ticket_tier']?['name']?.toString() ?? 'Tiket',
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
  final String? simulationKey;
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
    this.simulationKey,
    this.createdAt,
    this.items = const [],
  });

  bool get isPaid => status.toLowerCase() == 'paid' || status.toLowerCase() == 'success';
  bool get isPending => status.toLowerCase() == 'pending';
  bool get isCancelled => status.toLowerCase() == 'cancelled' || status.toLowerCase() == 'cancel';
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

    final paymentDetails = json['payment_details'] is Map
        ? Map<String, dynamic>.from(json['payment_details'] as Map)
        : null;

    final statusStr = json['payment_status']?.toString() ?? json['status']?.toString() ?? 'pending';
    final paymentMethodStr = json['payment_method']?.toString() ??
        paymentDetails?['payment_method']?.toString() ??
        paymentDetails?['payment_type']?.toString();
    final paymentUrlStr = json['payment_url']?.toString() ??
        paymentDetails?['payment_url']?.toString() ??
        paymentDetails?['snap_redirect_url']?.toString();
    final qrCodeUrlStr = json['qr_code_url']?.toString() ??
        paymentDetails?['qr_code_url']?.toString() ??
        paymentDetails?['qr_code_image_url']?.toString() ??
        json['qr_code_image_url']?.toString() ??
        paymentDetails?['qris_url']?.toString() ??
        paymentDetails?['qr_string']?.toString() ??
        json['qr_string']?.toString();
    final vaNumberStr = json['va_number']?.toString() ?? paymentDetails?['va_number']?.toString();
    final orderCodeVal = json['order_code']?.toString() ?? json['code']?.toString() ?? json['id']?.toString() ?? '';

    String? rawSimulationKey = json['simulation_key']?.toString() ??
        paymentDetails?['simulation_key']?.toString();

    // Ignore simulation_key if it's accidentally populated with order_code
    if (rawSimulationKey != null &&
        (rawSimulationKey == orderCodeVal || rawSimulationKey.startsWith('ORD-'))) {
      rawSimulationKey = null;
    }

    final simulationKeyStr = rawSimulationKey ?? qrCodeUrlStr;

    final totalAmountVal = json['total_amount'] is num
        ? json['total_amount'] as num
        : json['gross_amount'] is num
            ? json['gross_amount'] as num
            : paymentDetails?['gross_amount'] is num
                ? paymentDetails!['gross_amount'] as num
                : num.tryParse(json['total_amount']?.toString() ??
                        json['gross_amount']?.toString() ??
                        paymentDetails?['gross_amount']?.toString() ??
                        '0') ??
                    0;

    return OrderModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderCode: orderCodeVal,
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      eventId: json['event_id'] is int ? json['event_id'] : int.tryParse(json['event_id']?.toString() ?? '0') ?? 0,
      eventTitle: json['event_name']?.toString() ?? json['event_title']?.toString() ?? json['event']?['title']?.toString() ?? json['event']?['name']?.toString(),
      eventBanner: json['event_banner']?.toString() ?? json['event']?['banner_url']?.toString(),
      totalAmount: totalAmountVal,
      status: statusStr.toLowerCase(),
      paymentMethod: paymentMethodStr,
      paymentUrl: paymentUrlStr,
      qrCodeUrl: qrCodeUrlStr,
      vaNumber: vaNumberStr,
      simulationKey: simulationKeyStr,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
      items: orderItems,
    );
  }

  OrderModel mergeWith(OrderModel other) {
    String? resolvedSimKey;
    if (other.simulationKey != null &&
        !other.simulationKey!.startsWith('ORD-') &&
        other.simulationKey != other.orderCode) {
      resolvedSimKey = other.simulationKey;
    } else if (simulationKey != null &&
        !simulationKey!.startsWith('ORD-') &&
        simulationKey != orderCode) {
      resolvedSimKey = simulationKey;
    } else {
      resolvedSimKey = other.qrCodeUrl ?? qrCodeUrl;
    }

    return OrderModel(
      id: other.id != 0 ? other.id : id,
      orderCode: other.orderCode.isNotEmpty ? other.orderCode : orderCode,
      userId: other.userId != 0 ? other.userId : userId,
      eventId: other.eventId != 0 ? other.eventId : eventId,
      eventTitle: (other.eventTitle != null && other.eventTitle!.isNotEmpty) ? other.eventTitle : eventTitle,
      eventBanner: (other.eventBanner != null && other.eventBanner!.isNotEmpty) ? other.eventBanner : eventBanner,
      totalAmount: other.totalAmount > 0 ? other.totalAmount : totalAmount,
      status: other.status.isNotEmpty ? other.status : status,
      paymentMethod: other.paymentMethod ?? paymentMethod,
      paymentUrl: other.paymentUrl ?? paymentUrl,
      qrCodeUrl: other.qrCodeUrl ?? qrCodeUrl,
      vaNumber: other.vaNumber ?? vaNumber,
      simulationKey: resolvedSimKey,
      createdAt: other.createdAt ?? createdAt,
      items: other.items.isNotEmpty ? other.items : items,
    );
  }

  OrderModel copyWith({
    int? id,
    String? orderCode,
    int? userId,
    int? eventId,
    String? eventTitle,
    String? eventBanner,
    num? totalAmount,
    String? status,
    String? paymentMethod,
    String? paymentUrl,
    String? qrCodeUrl,
    String? vaNumber,
    String? simulationKey,
    DateTime? createdAt,
    List<OrderItemModel>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      eventTitle: eventTitle ?? this.eventTitle,
      eventBanner: eventBanner ?? this.eventBanner,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentUrl: paymentUrl ?? this.paymentUrl,
      qrCodeUrl: qrCodeUrl ?? this.qrCodeUrl,
      vaNumber: vaNumber ?? this.vaNumber,
      simulationKey: simulationKey ?? this.simulationKey,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_code': orderCode,
      'user_id': userId,
      'event_id': eventId,
      'event_title': eventTitle,
      'event_name': eventTitle,
      'event_banner': eventBanner,
      'total_amount': totalAmount,
      'status': status,
      'payment_status': status,
      'payment_method': paymentMethod,
      'payment_url': paymentUrl,
      'qr_code_url': qrCodeUrl,
      'va_number': vaNumber,
      'simulation_key': simulationKey,
      'created_at': createdAt?.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

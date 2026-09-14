import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/order_model.dart';

final orderApiServiceProvider = Provider<OrderApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return OrderApiService(dioClient);
});

class OrderApiService {
  final DioClient _dioClient;

  OrderApiService(this._dioClient);

  Future<OrderModel> createOrder({
    required int eventId,
    required List<Map<String, dynamic>> items, // [{'ticket_tier_id': 1, 'quantity': 2}]
    String? attendeeName,
    String? attendeeEmail,
    String? attendeePhone,
    String? paymentMethod,
  }) async {
    final response = await _dioClient.post(
      ApiConstants.orders,
      data: {
        'event_id': eventId,
        'items': items,
        if (attendeeName != null) 'attendee_name': attendeeName,
        if (attendeeEmail != null) 'attendee_email': attendeeEmail,
        if (attendeePhone != null) 'attendee_phone': attendeePhone,
        if (paymentMethod != null) 'payment_method': paymentMethod.toLowerCase(),
      },
    );

    final responseData = response.data;
    Map<String, dynamic> orderJson = {};

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is Map<String, dynamic>) {
        orderJson = responseData['data'] as Map<String, dynamic>;
      } else if (responseData['order'] is Map<String, dynamic>) {
        orderJson = responseData['order'] as Map<String, dynamic>;
      } else {
        orderJson = responseData;
      }
    }

    return OrderModel.fromJson(orderJson);
  }

  Future<OrderModel> getOrderByCode(String code) async {
    final response = await _dioClient.get(ApiConstants.orderDetail(code));

    final responseData = response.data;
    Map<String, dynamic> orderJson = {};

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is Map<String, dynamic>) {
        orderJson = responseData['data'] as Map<String, dynamic>;
      } else if (responseData['order'] is Map<String, dynamic>) {
        orderJson = responseData['order'] as Map<String, dynamic>;
      } else {
        orderJson = responseData;
      }
    }

    return OrderModel.fromJson(orderJson);
  }

  Future<List<OrderModel>> getMyOrders() async {
    final response = await _dioClient.get(ApiConstants.myOrders);

    final responseData = response.data;
    List<dynamic> items = [];

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is Map<String, dynamic> && responseData['data']['items'] is List) {
        items = responseData['data']['items'] as List;
      } else if (responseData['data'] is List) {
        items = responseData['data'] as List;
      } else if (responseData['orders'] is List) {
        items = responseData['orders'] as List;
      }
    } else if (responseData is List) {
      items = responseData;
    }

    return items
        .map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}

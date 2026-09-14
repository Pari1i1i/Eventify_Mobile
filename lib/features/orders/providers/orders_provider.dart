import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/order_model.dart';
import '../services/order_api_service.dart';

class OrdersState {
  final List<OrderModel> orders;
  final bool isLoading;
  final String? errorMessage;

  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  OrdersState copyWith({
    List<OrderModel>? orders,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class OrdersNotifier extends StateNotifier<OrdersState> {
  final OrderApiService _apiService;

  OrdersNotifier(this._apiService) : super(const OrdersState()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final items = await _apiService.getMyOrders();
      state = state.copyWith(
        orders: items,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : e.toString(),
      );
    }
  }
}

final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  final apiService = ref.watch(orderApiServiceProvider);
  return OrdersNotifier(apiService);
});

final orderDetailProvider = FutureProvider.family<OrderModel, String>((ref, code) async {
  final apiService = ref.watch(orderApiServiceProvider);
  return await apiService.getOrderByCode(code);
});

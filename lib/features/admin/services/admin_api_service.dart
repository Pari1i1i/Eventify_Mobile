import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../auth/models/user_model.dart';
import '../../orders/models/order_model.dart';
import '../models/admin_stats_model.dart';

final adminApiServiceProvider = Provider<AdminApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AdminApiService(dioClient);
});

class AdminApiService {
  final DioClient _dioClient;

  AdminApiService(this._dioClient);

  Future<AdminDashboardStats> getDashboardStats() async {
    final response = await _dioClient.get(ApiConstants.adminDashboard);

    final responseData = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};

    return AdminDashboardStats.fromJson(responseData);
  }

  Future<List<UserModel>> getUsers({String? search, String? role}) async {
    final query = <String, dynamic>{};
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (role != null && role.isNotEmpty) query['role'] = role;

    final response = await _dioClient.get(
      ApiConstants.adminUsers,
      queryParameters: query.isNotEmpty ? query : null,
    );

    final responseData = response.data;
    List<dynamic> items = [];

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is Map<String, dynamic> && responseData['data']['items'] is List) {
        items = responseData['data']['items'] as List;
      } else if (responseData['data'] is List) {
        items = responseData['data'] as List;
      } else if (responseData['users'] is List) {
        items = responseData['users'] as List;
      }
    } else if (responseData is List) {
      items = responseData;
    }

    return items
        .map((e) => UserModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<UserModel> updateUserRole(int userId, String newRole) async {
    final response = await _dioClient.put(
      ApiConstants.adminUserRole(userId),
      data: {'role': newRole.toLowerCase()},
    );

    final responseData = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};

    final userJson = responseData['data'] is Map<String, dynamic>
        ? responseData['data'] as Map<String, dynamic>
        : responseData['user'] is Map<String, dynamic>
            ? responseData['user'] as Map<String, dynamic>
            : responseData;

    return UserModel.fromJson(userJson);
  }

  Future<List<OrderModel>> getAllOrders({String? search, String? status}) async {
    final query = <String, dynamic>{};
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (status != null && status.isNotEmpty) query['status'] = status;

    final response = await _dioClient.get(
      ApiConstants.adminOrders,
      queryParameters: query.isNotEmpty ? query : null,
    );

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

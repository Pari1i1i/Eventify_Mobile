import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/models/user_model.dart';
import '../../orders/models/order_model.dart';
import '../models/admin_stats_model.dart';
import '../services/admin_api_service.dart';

final adminDashboardStatsProvider = FutureProvider<AdminDashboardStats>((ref) async {
  final adminApi = ref.watch(adminApiServiceProvider);
  return await adminApi.getDashboardStats();
});

class AdminUsersState {
  final List<UserModel> users;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;
  final String? selectedRole;

  const AdminUsersState({
    this.users = const [],
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
    this.selectedRole,
  });

  AdminUsersState copyWith({
    List<UserModel>? users,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
    String? selectedRole,
  }) {
    return AdminUsersState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedRole: selectedRole ?? this.selectedRole,
    );
  }
}

class AdminUsersNotifier extends StateNotifier<AdminUsersState> {
  final AdminApiService _adminApi;

  AdminUsersNotifier(this._adminApi) : super(const AdminUsersState()) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final items = await _adminApi.getUsers(
        search: state.searchQuery,
        role: state.selectedRole,
      );
      state = state.copyWith(users: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> changeUserRole(int userId, String newRole) async {
    try {
      final updated = await _adminApi.updateUserRole(userId, newRole);
      state = state.copyWith(
        users: state.users.map((u) => u.id == userId ? updated : u).toList(),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  void setSearch(String query) {
    state = state.copyWith(searchQuery: query);
    loadUsers();
  }

  void setRole(String? role) {
    state = state.copyWith(selectedRole: role);
    loadUsers();
  }
}

final adminUsersProvider = StateNotifierProvider<AdminUsersNotifier, AdminUsersState>((ref) {
  final adminApi = ref.watch(adminApiServiceProvider);
  return AdminUsersNotifier(adminApi);
});

final adminOrdersProvider = FutureProvider<List<OrderModel>>((ref) async {
  final adminApi = ref.watch(adminApiServiceProvider);
  return await adminApi.getAllOrders();
});

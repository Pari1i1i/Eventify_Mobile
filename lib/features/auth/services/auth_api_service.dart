import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/user_model.dart';

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AuthApiService(dioClient);
});

class AuthApiService {
  final DioClient _dioClient;

  AuthApiService(this._dioClient);

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _dioClient.post(
      ApiConstants.login,
      data: {
        'email': email.trim(),
        'password': password,
      },
    );

    final responseData = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};

    return AuthResponse.fromJson(responseData);
  }

  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    String role = 'customer',
  }) async {
    final response = await _dioClient.post(
      ApiConstants.register,
      data: {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
        'role': role,
      },
    );

    final responseData = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};

    return AuthResponse.fromJson(responseData);
  }

  Future<UserModel> getMe() async {
    final response = await _dioClient.get(ApiConstants.me);

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

  Future<UserModel> updateProfile({
    required String name,
    String? phone,
  }) async {
    final response = await _dioClient.put(
      ApiConstants.me,
      data: {
        'name': name.trim(),
        if (phone != null) 'phone': phone.trim(),
      },
    );

    final responseData = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};

    final userJson = responseData['data'] is Map<String, dynamic>
        ? responseData['data'] as Map<String, dynamic>
        : responseData;

    return UserModel.fromJson(userJson);
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await _dioClient.put(
      ApiConstants.changePassword,
      data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      },
    );
  }
}

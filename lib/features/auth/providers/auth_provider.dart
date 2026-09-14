import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/storage/local_cache_service.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../models/user_model.dart';
import '../services/auth_api_service.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? token;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.token,
    this.errorMessage,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get isLoading => status == AuthStatus.loading;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? token,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      token: token ?? this.token,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthApiService _authApiService;
  final SecureStorageService _secureStorage;
  final LocalCacheService _localCache;

  AuthNotifier({
    required AuthApiService authApiService,
    required SecureStorageService secureStorage,
    required LocalCacheService localCache,
  })  : _authApiService = authApiService,
        _secureStorage = secureStorage,
        _localCache = localCache,
        super(const AuthState());

  Future<void> checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final token = await _secureStorage.getToken();
      if (token == null || token.isEmpty) {
        state = state.copyWith(status: AuthStatus.unauthenticated, user: null, token: null);
        return;
      }

      // Try fetching current user profile from server
      try {
        final user = await _authApiService.getMe();
        await _localCache.saveUserData(user.toJson());
        state = AuthState(
          status: AuthStatus.authenticated,
          user: user,
          token: token,
        );
      } catch (e) {
        // Fallback to local cached user if offline
        final cachedUserJson = _localCache.getUserData();
        if (cachedUserJson != null) {
          final cachedUser = UserModel.fromJson(cachedUserJson);
          state = AuthState(
            status: AuthStatus.authenticated,
            user: cachedUser,
            token: token,
          );
        } else {
          // Token is invalid or expired
          await _secureStorage.deleteToken();
          state = state.copyWith(status: AuthStatus.unauthenticated, user: null, token: null);
        }
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final response = await _authApiService.login(
        email: email,
        password: password,
      );

      await _secureStorage.saveToken(response.token);
      await _localCache.saveUserData(response.user.toJson());

      state = AuthState(
        status: AuthStatus.authenticated,
        user: response.user,
        token: response.token,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String role = 'customer',
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final response = await _authApiService.register(
        name: name,
        email: email,
        password: password,
        role: role,
      );

      await _secureStorage.saveToken(response.token);
      await _localCache.saveUserData(response.user.toJson());

      state = AuthState(
        status: AuthStatus.authenticated,
        user: response.user,
        token: response.token,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> loginWithGoogle({
    required String email,
    required String name,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      // Default google password representation for unified backend auth
      const googleDefaultPass = 'GoogleAuth2026!Eventify';

      // 1. Try login first
      try {
        final response = await _authApiService.login(
          email: email,
          password: googleDefaultPass,
        );

        await _secureStorage.saveToken(response.token);
        await _localCache.saveUserData(response.user.toJson());

        state = AuthState(
          status: AuthStatus.authenticated,
          user: response.user,
          token: response.token,
        );
        return true;
      } catch (_) {
        // 2. If user not registered yet, register as customer automatically
        final registerResponse = await _authApiService.register(
          name: name.isNotEmpty ? name : email.split('@').first,
          email: email,
          password: googleDefaultPass,
          role: 'customer',
        );

        await _secureStorage.saveToken(registerResponse.token);
        await _localCache.saveUserData(registerResponse.user.toJson());

        state = AuthState(
          status: AuthStatus.authenticated,
          user: registerResponse.user,
          token: registerResponse.token,
        );
        return true;
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateProfile({
    required String name,
    String? phone,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      final updatedUser = await _authApiService.updateProfile(
        name: name,
        phone: phone,
      );

      await _localCache.saveUserData(updatedUser.toJson());

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: updatedUser,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.authenticated, // retain authenticated
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _authApiService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      state = state.copyWith(status: AuthStatus.authenticated);
      return true;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.deleteToken();
    await _localCache.clearUserData();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authApiService = ref.watch(authApiServiceProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final localCache = ref.watch(localCacheServiceProvider);

  final notifier = AuthNotifier(
    authApiService: authApiService,
    secureStorage: secureStorage,
    localCache: localCache,
  );

  // Setup auto logout callback on 401
  ref.read(dioClientProvider).onUnauthorized = () {
    notifier.logout();
  };

  return notifier;
});

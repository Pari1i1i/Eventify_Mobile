import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage_service.dart';
import '../storage/local_cache_service.dart';
import 'api_exceptions.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final localCacheServiceProvider = Provider<LocalCacheService>((ref) {
  throw UnimplementedError('localCacheServiceProvider must be initialized in main');
});

// Callback for 401 unauthenticated
typedef OnUnauthorizedCallback = void Function();

class DioClient {
  late final Dio dio;
  final SecureStorageService secureStorage;
  final LocalCacheService localCache;
  OnUnauthorizedCallback? onUnauthorized;

  DioClient({
    required this.secureStorage,
    required this.localCache,
    this.onUnauthorized,
  }) {
    final activeBaseUrl = localCache.getBaseUrl();
    ApiConstants.baseUrl = activeBaseUrl;

    dio = Dio(
      BaseOptions(
        baseUrl: activeBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _setupInterceptors();
  }

  void updateBaseUrl(String newUrl) {
    ApiConstants.baseUrl = newUrl;
    dio.options.baseUrl = newUrl;
    localCache.saveBaseUrl(newUrl);
  }

  void _setupInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Attach JWT token if present
          final token = await secureStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) {
            debugPrint('[DIO REQ] ${options.method} ${options.baseUrl}${options.path}');
            if (options.data != null) {
              debugPrint('[DIO DATA] ${options.data}');
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('[DIO RES] ${response.statusCode} ${response.requestOptions.path}');
          }
          return handler.next(response);
        },
        onError: (DioException err, handler) async {
          if (kDebugMode) {
            debugPrint('[DIO ERR] ${err.response?.statusCode}: ${err.message}');
            debugPrint('[DIO ERR DATA] ${err.response?.data}');
          }

          // Auto-logout when 401 Unauthorized
          if (err.response?.statusCode == 401) {
            // Check if not calling login or register
            final path = err.requestOptions.path;
            if (!path.contains('/auth/login') && !path.contains('/auth/register')) {
              await secureStorage.deleteToken();
              await localCache.clearUserData();
              onUnauthorized?.call();
            }
          }

          return handler.next(err);
        },
      ),
    );
  }

  // HTTP helper methods wrapping with ApiException
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.get(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.post(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.put(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await dio.delete(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}

final dioClientProvider = Provider<DioClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final localCache = ref.watch(localCacheServiceProvider);

  return DioClient(
    secureStorage: secureStorage,
    localCache: localCache,
  );
});

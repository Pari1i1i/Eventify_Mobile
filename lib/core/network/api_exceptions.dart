import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  factory ApiException.fromDioError(DioException dioException) {
    String message = 'Terjadi kesalahan koneksi ke server';
    final statusCode = dioException.response?.statusCode;
    final responseData = dioException.response?.data;

    if (responseData is Map<String, dynamic>) {
      if (responseData['message'] != null) {
        message = responseData['message'].toString();
      } else if (responseData['error'] != null) {
        message = responseData['error'].toString();
      }
    } else if (responseData is String && responseData.isNotEmpty) {
      message = responseData;
    }

    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Koneksi waktu habis. Periksa jaringan Anda.';
        break;
      case DioExceptionType.badResponse:
        if (statusCode == 401) {
          message = message.isNotEmpty ? message : 'Sesi Anda telah berakhir. Silakan login kembali.';
        } else if (statusCode == 403) {
          message = 'Anda tidak memiliki hak akses untuk tindakan ini.';
        } else if (statusCode == 404) {
          message = message.isNotEmpty ? message : 'Data tidak ditemukan.';
        } else if (statusCode == 422 || statusCode == 400) {
          message = message.isNotEmpty ? message : 'Permintaan tidak valid.';
        } else if (statusCode != null && statusCode >= 500) {
          message = 'Terjadi kesalahan internal pada server ($statusCode).';
        }
        break;
      case DioExceptionType.cancel:
        message = 'Permintaan dibatalkan.';
        break;
      case DioExceptionType.connectionError:
        message = 'Gagal terhubung ke server. Pastikan backend aktif di ${dioException.requestOptions.baseUrl}';
        break;
      default:
        break;
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      data: responseData,
    );
  }

  @override
  String toString() => message;
}

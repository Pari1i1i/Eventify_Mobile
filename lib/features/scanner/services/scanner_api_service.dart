import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../models/scan_result_model.dart';

final scannerApiServiceProvider = Provider<ScannerApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ScannerApiService(dioClient);
});

class ScannerApiService {
  final DioClient _dioClient;

  ScannerApiService(this._dioClient);

  Future<ScanResultModel> checkIn(String ticketCode) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.scannerCheckIn,
        data: {
          'code': ticketCode.trim(),
          'ticket_code': ticketCode.trim(),
        },
      );

      final responseData = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};

      return ScanResultModel.fromJson(responseData, ticketCode);
    } on ApiException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('sudah') || msg.contains('already') || msg.contains('duplikat') || msg.contains('used') || msg.contains('terpakai')) {
        return ScanResultModel(
          status: ScanStatus.duplicate,
          message: e.message,
          ticketCode: ticketCode,
        );
      } else {
        return ScanResultModel(
          status: ScanStatus.invalid,
          message: e.message,
          ticketCode: ticketCode,
        );
      }
    } catch (e) {
      return ScanResultModel(
        status: ScanStatus.invalid,
        message: e.toString(),
        ticketCode: ticketCode,
      );
    }
  }
}

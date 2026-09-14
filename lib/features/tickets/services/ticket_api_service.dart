import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/ticket_model.dart';

final ticketApiServiceProvider = Provider<TicketApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return TicketApiService(dioClient);
});

class TicketApiService {
  final DioClient _dioClient;

  TicketApiService(this._dioClient);

  Future<List<TicketModel>> getMyTickets() async {
    final response = await _dioClient.get(ApiConstants.myTickets);

    final responseData = response.data;
    List<dynamic> items = [];

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is List) {
        items = responseData['data'] as List;
      } else if (responseData['tickets'] is List) {
        items = responseData['tickets'] as List;
      }
    } else if (responseData is List) {
      items = responseData;
    }

    return items
        .map((e) => TicketModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<TicketModel> getTicketByCode(String code) async {
    final response = await _dioClient.get(ApiConstants.ticketDetail(code));

    final responseData = response.data;
    Map<String, dynamic> ticketJson = {};

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is Map<String, dynamic>) {
        ticketJson = responseData['data'] as Map<String, dynamic>;
      } else if (responseData['ticket'] is Map<String, dynamic>) {
        ticketJson = responseData['ticket'] as Map<String, dynamic>;
      } else {
        ticketJson = responseData;
      }
    }

    return TicketModel.fromJson(ticketJson);
  }
}

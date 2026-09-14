import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../models/event_model.dart';

final eventApiServiceProvider = Provider<EventApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return EventApiService(dioClient);
});

class EventApiService {
  final DioClient _dioClient;

  EventApiService(this._dioClient);

  Future<List<EventModel>> getEvents({
    String? search,
    String? startDate,
    String? endDate,
    int page = 1,
    int limit = 10,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }
    if (startDate != null && startDate.isNotEmpty) {
      query['start_date'] = startDate;
    }
    if (endDate != null && endDate.isNotEmpty) {
      query['end_date'] = endDate;
    }

    final response = await _dioClient.get(
      ApiConstants.events,
      queryParameters: query,
    );

    final responseData = response.data;
    List<dynamic> items = [];

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is Map<String, dynamic> && responseData['data']['items'] is List) {
        items = responseData['data']['items'] as List;
      } else if (responseData['data'] is List) {
        items = responseData['data'] as List;
      } else if (responseData['items'] is List) {
        items = responseData['items'] as List;
      } else if (responseData['events'] is List) {
        items = responseData['events'] as List;
      }
    } else if (responseData is List) {
      items = responseData;
    }

    return items
        .map((e) => EventModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<EventModel> getEventBySlug(String slug) async {
    final response = await _dioClient.get(ApiConstants.eventDetail(slug));

    final responseData = response.data;
    Map<String, dynamic> eventMap = {};

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is Map<String, dynamic>) {
        eventMap = responseData['data'] as Map<String, dynamic>;
      } else if (responseData['event'] is Map<String, dynamic>) {
        eventMap = responseData['event'] as Map<String, dynamic>;
      } else {
        eventMap = responseData;
      }
    }

    return EventModel.fromJson(eventMap);
  }
}

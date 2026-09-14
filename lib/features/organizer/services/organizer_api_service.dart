import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../events/models/event_model.dart';
import '../../events/models/ticket_tier_model.dart';

final organizerApiServiceProvider = Provider<OrganizerApiService>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return OrganizerApiService(dioClient);
});

class OrganizerApiService {
  final DioClient _dioClient;

  OrganizerApiService(this._dioClient);

  Future<List<EventModel>> getMyEvents() async {
    final response = await _dioClient.get(ApiConstants.organizerMyEvents);

    final responseData = response.data;
    List<dynamic> items = [];

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is Map<String, dynamic> && responseData['data']['items'] is List) {
        items = responseData['data']['items'] as List;
      } else if (responseData['data'] is List) {
        items = responseData['data'] as List;
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

  Future<EventModel> createEvent(Map<String, dynamic> eventData) async {
    final response = await _dioClient.post(
      ApiConstants.organizerEvents,
      data: eventData,
    );

    final responseData = response.data;
    Map<String, dynamic> eventJson = {};

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is Map<String, dynamic>) {
        eventJson = responseData['data'] as Map<String, dynamic>;
      } else if (responseData['event'] is Map<String, dynamic>) {
        eventJson = responseData['event'] as Map<String, dynamic>;
      } else {
        eventJson = responseData;
      }
    }

    return EventModel.fromJson(eventJson);
  }

  Future<void> uploadBanner(int eventId, XFile file) async {
    final formData = FormData.fromMap({
      'banner': await MultipartFile.fromFile(
        file.path,
        filename: file.name,
      ),
    });

    await _dioClient.post(
      ApiConstants.organizerEventBanner(eventId),
      data: formData,
      options: Options(
        headers: {'Content-Type': 'multipart/form-data'},
      ),
    );
  }

  Future<EventModel> updateEvent(int eventId, Map<String, dynamic> eventData) async {
    final response = await _dioClient.put(
      ApiConstants.organizerEventDetail(eventId),
      data: eventData,
    );

    final responseData = response.data;
    Map<String, dynamic> eventJson = {};

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is Map<String, dynamic>) {
        eventJson = responseData['data'] as Map<String, dynamic>;
      } else if (responseData['event'] is Map<String, dynamic>) {
        eventJson = responseData['event'] as Map<String, dynamic>;
      } else {
        eventJson = responseData;
      }
    }

    return EventModel.fromJson(eventJson);
  }

  Future<void> deleteEvent(int eventId) async {
    await _dioClient.delete(ApiConstants.organizerEventDetail(eventId));
  }

  Future<TicketTierModel> createTicketTier(Map<String, dynamic> tierData) async {
    final response = await _dioClient.post(
      ApiConstants.organizerTicketTiers,
      data: tierData,
    );

    final responseData = response.data;
    Map<String, dynamic> tierJson = {};

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is Map<String, dynamic>) {
        tierJson = responseData['data'] as Map<String, dynamic>;
      } else {
        tierJson = responseData;
      }
    }

    return TicketTierModel.fromJson(tierJson);
  }

  Future<TicketTierModel> updateTicketTier(int tierId, Map<String, dynamic> tierData) async {
    final response = await _dioClient.put(
      ApiConstants.organizerTicketTierDetail(tierId),
      data: tierData,
    );

    final responseData = response.data;
    Map<String, dynamic> tierJson = {};

    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is Map<String, dynamic>) {
        tierJson = responseData['data'] as Map<String, dynamic>;
      } else {
        tierJson = responseData;
      }
    }

    return TicketTierModel.fromJson(tierJson);
  }

  Future<void> deleteTicketTier(int tierId) async {
    await _dioClient.delete(ApiConstants.organizerTicketTierDetail(tierId));
  }
}

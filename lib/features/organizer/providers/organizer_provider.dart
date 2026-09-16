import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exceptions.dart';
import '../../events/models/event_model.dart';
import '../services/organizer_api_service.dart';

class OrganizerState {
  final List<EventModel> events;
  final bool isLoading;
  final String? errorMessage;

  const OrganizerState({
    this.events = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  int get totalTicketsSold {
    int count = 0;
    for (final e in events) {
      for (final t in e.ticketTiers) {
        final sold = t.quota - t.remainingQuota;
        if (sold > 0) count += sold;
      }
    }
    return count;
  }

  int get totalTicketsQuota {
    int count = 0;
    for (final e in events) {
      for (final t in e.ticketTiers) {
        count += t.quota;
      }
    }
    return count;
  }

  num get totalEstimatedRevenue {
    num total = 0;
    for (final e in events) {
      for (final t in e.ticketTiers) {
        final sold = t.quota - t.remainingQuota;
        if (sold > 0) {
          total += (sold * t.price);
        }
      }
    }
    return total;
  }

  int get activeEventsCount =>
      events.where((e) => e.status.toLowerCase() == 'published').length;

  EventModel? get focusEvent {
    if (events.isEmpty) return null;
    // Prefer the first published event, or fallback to the latest created event
    final published = events.where((e) => e.status.toLowerCase() == 'published').toList();
    if (published.isNotEmpty) {
      return published.first;
    }
    return events.first;
  }

  OrganizerState copyWith({
    List<EventModel>? events,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OrganizerState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class OrganizerNotifier extends StateNotifier<OrganizerState> {
  final OrganizerApiService _apiService;

  OrganizerNotifier(this._apiService) : super(const OrganizerState()) {
    loadMyEvents();
  }

  Future<void> loadMyEvents() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final items = await _apiService.getMyEvents();
      state = state.copyWith(
        events: items,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is ApiException ? e.message : e.toString(),
      );
    }
  }

  Future<bool> deleteEvent(int eventId) async {
    try {
      await _apiService.deleteEvent(eventId);
      state = state.copyWith(
        events: state.events.where((e) => e.id != eventId).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}

final organizerProvider = StateNotifierProvider<OrganizerNotifier, OrganizerState>((ref) {
  final apiService = ref.watch(organizerApiServiceProvider);
  return OrganizerNotifier(apiService);
});

// Session check-in counter (increments in real-time during scan session)
final checkInSessionCounterProvider = StateProvider<int>((ref) => 0);

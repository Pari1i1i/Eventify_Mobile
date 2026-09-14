import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../models/event_model.dart';
import '../services/event_api_service.dart';

class EventsState {
  final List<EventModel> events;
  final bool isLoading;
  final bool isLoadMore;
  final bool hasMore;
  final int page;
  final String searchQuery;
  final String? startDate;
  final String? endDate;
  final String? errorMessage;

  const EventsState({
    this.events = const [],
    this.isLoading = false,
    this.isLoadMore = false,
    this.hasMore = true,
    this.page = 1,
    this.searchQuery = '',
    this.startDate,
    this.endDate,
    this.errorMessage,
  });

  EventsState copyWith({
    List<EventModel>? events,
    bool? isLoading,
    bool? isLoadMore,
    bool? hasMore,
    int? page,
    String? searchQuery,
    String? startDate,
    String? endDate,
    String? errorMessage,
  }) {
    return EventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      isLoadMore: isLoadMore ?? this.isLoadMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      errorMessage: errorMessage,
    );
  }
}

class EventsNotifier extends StateNotifier<EventsState> {
  final EventApiService _apiService;
  final Ref _ref;

  EventsNotifier(this._apiService, this._ref) : super(const EventsState()) {
    loadEvents();
  }

  Future<void> loadEvents({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(page: 1, hasMore: true, isLoading: true, errorMessage: null);
    } else {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    try {
      final items = await _apiService.getEvents(
        search: state.searchQuery,
        startDate: state.startDate,
        endDate: state.endDate,
        page: 1,
        limit: 10,
      );

      // Cache events locally for offline fallback
      if (items.isNotEmpty) {
        _ref.read(localCacheServiceProvider).cacheEvents(items.map((e) => e.toJson()).toList());
      }

      state = state.copyWith(
        events: items,
        isLoading: false,
        page: 1,
        hasMore: items.length >= 10,
      );
    } catch (e) {
      // Offline fallback
      final cached = _ref.read(localCacheServiceProvider).getCachedEvents();
      if (cached.isNotEmpty) {
        final cachedEvents = cached.map((c) => EventModel.fromJson(c)).toList();
        state = state.copyWith(
          events: cachedEvents,
          isLoading: false,
          errorMessage: 'Menampilkan data tersimpan (offline)',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: e is ApiException ? e.message : e.toString(),
        );
      }
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadMore || !state.hasMore) return;

    final nextPage = state.page + 1;
    state = state.copyWith(isLoadMore: true);

    try {
      final items = await _apiService.getEvents(
        search: state.searchQuery,
        startDate: state.startDate,
        endDate: state.endDate,
        page: nextPage,
        limit: 10,
      );

      state = state.copyWith(
        events: [...state.events, ...items],
        page: nextPage,
        isLoadMore: false,
        hasMore: items.length >= 10,
      );
    } catch (e) {
      state = state.copyWith(isLoadMore: false);
    }
  }

  void setSearchQuery(String query) {
    if (state.searchQuery != query) {
      state = state.copyWith(searchQuery: query);
      loadEvents(refresh: true);
    }
  }

  void setDateFilter(String? start, String? end) {
    state = state.copyWith(startDate: start, endDate: end);
    loadEvents(refresh: true);
  }

  void clearFilters() {
    state = state.copyWith(searchQuery: '', startDate: null, endDate: null);
    loadEvents(refresh: true);
  }
}

final eventsProvider = StateNotifierProvider<EventsNotifier, EventsState>((ref) {
  final apiService = ref.watch(eventApiServiceProvider);
  return EventsNotifier(apiService, ref);
});

final eventDetailProvider = FutureProvider.family<EventModel, String>((ref, slug) async {
  final apiService = ref.watch(eventApiServiceProvider);
  return await apiService.getEventBySlug(slug);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../models/ticket_model.dart';
import '../services/ticket_api_service.dart';

class TicketsState {
  final List<TicketModel> tickets;
  final bool isLoading;
  final bool isOffline;
  final String? errorMessage;

  const TicketsState({
    this.tickets = const [],
    this.isLoading = false,
    this.isOffline = false,
    this.errorMessage,
  });

  List<TicketModel> get activeTickets =>
      tickets.where((t) => t.isValid).toList();

  List<TicketModel> get usedTickets =>
      tickets.where((t) => !t.isValid).toList();

  TicketsState copyWith({
    List<TicketModel>? tickets,
    bool? isLoading,
    bool? isOffline,
    String? errorMessage,
  }) {
    return TicketsState(
      tickets: tickets ?? this.tickets,
      isLoading: isLoading ?? this.isLoading,
      isOffline: isOffline ?? this.isOffline,
      errorMessage: errorMessage,
    );
  }
}

class TicketsNotifier extends StateNotifier<TicketsState> {
  final TicketApiService _apiService;
  final Ref _ref;

  TicketsNotifier(this._apiService, this._ref) : super(const TicketsState()) {
    loadTickets();
  }

  Future<void> loadTickets() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final items = await _apiService.getMyTickets();
      // Cache tickets locally in SharedPreferences for offline access
      await _ref.read(localCacheServiceProvider).cacheTickets(
            items.map((e) => e.toJson()).toList(),
          );

      state = state.copyWith(
        tickets: items,
        isLoading: false,
        isOffline: false,
      );
    } catch (e) {
      // Load from local offline cache
      final cachedJson = _ref.read(localCacheServiceProvider).getCachedTickets();
      if (cachedJson.isNotEmpty) {
        final cachedTickets = cachedJson.map((e) => TicketModel.fromJson(e)).toList();
        state = state.copyWith(
          tickets: cachedTickets,
          isLoading: false,
          isOffline: true,
          errorMessage: 'Mode Offline: Menggunakan tiket tersimpan di perangkat.',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        );
      }
    }
  }
}

final ticketsProvider = StateNotifierProvider<TicketsNotifier, TicketsState>((ref) {
  final apiService = ref.watch(ticketApiServiceProvider);
  return TicketsNotifier(apiService, ref);
});

final ticketDetailProvider = FutureProvider.family<TicketModel, String>((ref, code) async {
  // First check if ticket is in state/cache
  final tickets = ref.read(ticketsProvider).tickets;
  final match = tickets.where((t) => t.ticketCode.toLowerCase() == code.toLowerCase()).firstOrNull;
  if (match != null) {
    return match;
  }

  // Otherwise fetch from API
  final apiService = ref.watch(ticketApiServiceProvider);
  return await apiService.getTicketByCode(code);
});

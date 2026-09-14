import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/constants/app_theme.dart';
import 'core/network/dio_client.dart';
import 'core/router/app_router.dart';
import 'core/storage/local_cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize date formatting locale
  await initializeDateFormatting('id_ID', null);

  // Initialize SharedPreferences local cache service
  final localCacheService = await LocalCacheService.init();

  runApp(
    ProviderScope(
      overrides: [
        localCacheServiceProvider.overrideWithValue(localCacheService),
      ],
      child: const EventifyApp(),
    ),
  );
}

class EventifyApp extends ConsumerWidget {
  const EventifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Eventify',
      theme: AppTheme.theme,
      routerConfig: router,
    );
  }
}

import 'package:get_it/get_it.dart';

import '../auth/session_guard.dart';
import '../config/app_config.dart';
import '../network/api_client.dart';
import '../printer/bluetooth_printer_service.dart';
import '../storage/preferences_service.dart';
import '../storage/secure_storage_service.dart';
import '../../features/menu/data/menu_repository.dart';
import '../../features/store_settings/data/store_settings_repository.dart';
import '../../features/transaction/data/transaction_repository.dart';

/// Global service locator. Use `locator<T>()` to resolve singletons anywhere.
final GetIt locator = GetIt.instance;

/// Registers all app-wide services. Call once at startup, after
/// [AppConfig.load].
Future<void> setupLocator() async {
  // Storage.
  final prefs = await PreferencesService.create();
  final sessionGuard = SessionGuard();
  locator
    ..registerSingleton<PreferencesService>(prefs)
    ..registerSingleton<SecureStorageService>(SecureStorageService())
    ..registerSingleton<SessionGuard>(sessionGuard);

  // Networking. Clears the session on 401/403 so the app can route to login.
  final secureStorage = locator<SecureStorageService>();
  final apiClient = ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    onSessionExpired: () => sessionGuard.notifyExpired(),
  );

  // Restore a previously saved auth token (if any) onto the client.
  final savedToken = await secureStorage.readToken();
  if (savedToken != null) apiClient.setAuthToken(savedToken);

  locator.registerSingleton<ApiClient>(apiClient);

  locator.registerLazySingleton<MenuRepository>(
    () => MenuRepository(locator<ApiClient>()),
  );

  locator.registerLazySingleton<TransactionRepository>(
    () => TransactionRepository(locator<ApiClient>()),
  );

  locator.registerLazySingleton<StoreSettingsRepository>(
    () => StoreSettingsRepository(locator<ApiClient>()),
  );

  locator.registerSingleton<BluetoothPrinterService>(
    PrintBluetoothThermalService(),
  );
}

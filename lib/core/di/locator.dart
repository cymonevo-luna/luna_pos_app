import 'package:get_it/get_it.dart';

import '../auth/session_guard.dart';
import '../auth/token_refresh_service.dart';
import '../config/app_config.dart';
import '../network/api_client.dart';
import '../printer/bluetooth_printer_service.dart';
import '../storage/preferences_service.dart';
import '../storage/secure_storage_service.dart';
import '../../features/menu/data/menu_repository.dart';
import '../../features/order/data/order_option_repository.dart';
import '../../features/purchase/data/purchase_image_picker.dart';
import '../../features/purchase/data/purchase_proof_upload.dart';
import '../../features/purchase/data/purchase_request_repository.dart';
import '../../features/purchase/data/supplier_repository.dart';
import '../../features/cashier_balance/data/cashier_balance_repository.dart';
import '../../features/recurring_expense/data/recurring_expense_repository.dart';
import '../../features/stock/data/food_supply_repository.dart';
import '../../features/store_settings/data/store_settings_repository.dart';
import '../../features/production_request/data/production_request_repository.dart';
import '../../features/receipt/receipt_print_service.dart';
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

  final tokenRefresh = TokenRefreshService(
    secureStorage: secureStorage,
    dio: apiClient.raw,
    onSessionExpired: () => sessionGuard.notifyExpired(),
  );
  apiClient.attachAuthInterceptor(tokenRefresh);

  // Restore a previously saved auth token (if any) onto the client.
  final savedToken = await secureStorage.readToken();
  if (savedToken != null) apiClient.setAuthToken(savedToken);

  locator
    ..registerSingleton<TokenRefreshService>(tokenRefresh)
    ..registerSingleton<ApiClient>(apiClient);

  locator.registerLazySingleton<MenuRepository>(
    () => MenuRepository(locator<ApiClient>()),
  );

  locator.registerLazySingleton<OrderOptionRepository>(
    () => OrderOptionRepository(locator<ApiClient>()),
  );

  locator.registerLazySingleton<TransactionRepository>(
    () => TransactionRepository(locator<ApiClient>()),
  );

  locator.registerLazySingleton<PurchaseRequestRepository>(
    () => PurchaseRequestRepository(locator<ApiClient>()),
  );

  locator.registerLazySingleton<PurchaseProofUpload>(
    () => PurchaseProofUpload(locator<ApiClient>()),
  );

  locator.registerLazySingleton<PurchaseImagePicker>(
    RealPurchaseImagePicker.new,
  );

  locator.registerLazySingleton<SupplierRepository>(
    () => SupplierRepository(locator<ApiClient>()),
  );

  locator.registerLazySingleton<StoreSettingsRepository>(
    () => StoreSettingsRepository(locator<ApiClient>()),
  );

  locator.registerLazySingleton<FoodSupplyRepository>(
    () => FoodSupplyRepository(locator<ApiClient>()),
  );

  locator.registerLazySingleton<RecurringExpenseRepository>(
    () => RecurringExpenseRepository(locator<ApiClient>()),
  );

  locator.registerLazySingleton<CashierBalanceRepository>(
    () => CashierBalanceRepository(locator<ApiClient>()),
  );

  locator.registerLazySingleton<ProductionRequestRepository>(
    () => ProductionRequestRepository(locator<ApiClient>()),
  );

  locator.registerSingleton<BluetoothPrinterService>(
    PrintBluetoothThermalService(),
  );

  locator.registerLazySingleton<ReceiptPrintService>(
    ReceiptPrintService.new,
  );
}

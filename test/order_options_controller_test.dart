import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/features/auth/auth_controller.dart';
import 'package:luna_pos/features/order/data/order_option_repository.dart';
import 'package:luna_pos/features/order/order_options_controller.dart';
import 'package:luna_pos/features/user/models/user.dart';

import 'helpers/auth_harness.dart';

class _FakeAuthController extends AuthController {
  @override
  AuthState build() => const AuthState(
        status: AuthStatus.authenticated,
        user: User(
          id: 'u1',
          name: 'Alex',
          email: 'a@b.com',
          merchantId: 'merchant-1',
          roles: ['cashier'],
        ),
      );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;
  late DioAdapter adapter;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    registerAuthTestServices(secure: FakeSecureStorage(), client: mocked.client);
    locator.registerLazySingleton<OrderOptionRepository>(
      () => OrderOptionRepository(locator<ApiClient>(), testResourceCache()),
    );
    stubOrderOptions(adapter);

    container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(_FakeAuthController.new),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('loadIfNeeded sorts options by priority descending', () async {
    await container.read(orderOptionsProvider.notifier).loadIfNeeded();

    final state = container.read(orderOptionsProvider);
    expect(state.loading, isFalse);
    expect(state.options, hasLength(2));
    expect(state.options.first.name, 'Take Away');
    expect(state.options.last.name, 'Dine In');
  });

  test('loadIfNeeded uses cache for same merchant', () async {
    await container.read(orderOptionsProvider.notifier).loadIfNeeded();
    adapter.reset();

    await container.read(orderOptionsProvider.notifier).loadIfNeeded();

    final state = container.read(orderOptionsProvider);
    expect(state.options, hasLength(2));
  });

  test('refresh reloads options after cache reset', () async {
    await container.read(orderOptionsProvider.notifier).loadIfNeeded();
    adapter.reset();
    stubOrderOptions(adapter);

    await container.read(orderOptionsProvider.notifier).refresh();

    expect(container.read(orderOptionsProvider).options, hasLength(2));
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/app.dart';
import 'package:luna_pos/core/auth/session_guard.dart';
import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/auth/login_page.dart';

import 'helpers/auth_harness.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerSingleton<SessionGuard>(SessionGuard())
      ..registerSingleton<SecureStorageService>(FakeSecureStorage())
      ..registerSingleton<ApiClient>(ApiClient(baseUrl: 'https://api.test'));
  });

  testWidgets('unauthenticated startup routes to the login screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    // The splash holds for a minimum display window before resolving auth and
    // routing. Advance past it, then let navigation settle.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pump();

    expect(find.byType(LoginPage), findsOneWidget);
  });
}

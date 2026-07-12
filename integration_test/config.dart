/// Integration-test configuration for dedicated account automation.
///
/// Override at run time with `--dart-define`, e.g.
/// `--dart-define=API_BASE_URL=https://pos-api.cymonevo.com`.
abstract final class IntegrationTestConfig {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.test',
  );

  /// When true, tests call the live API at [apiBaseUrl] instead of mocks.
  static const useLiveApi = bool.fromEnvironment(
    'INTEGRATION_USE_LIVE_API',
    defaultValue: false,
  );
}

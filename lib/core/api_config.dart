class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.startupet.et',
  );

  static const String apiKeyHeader = String.fromEnvironment(
    'API_KEY_HEADER',
    defaultValue: 'X-API-Key',
  );

  static const String defaultApiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}

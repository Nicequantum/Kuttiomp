class AppConstants {
  static const String appName = 'Kuttiomp';
  static const String tagline = 'Narragansett Language Revitalization';
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000',
  );
  static const String apiVersion = '0.4.0';
}
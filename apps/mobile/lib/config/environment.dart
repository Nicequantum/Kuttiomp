/// Runtime environment configuration for Kuttiomp mobile (§4, tribal-controlled).
class KuttiompEnvironment {
  const KuttiompEnvironment({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    this.appName = 'Kuttiomp',
    this.flavor = 'dev',
  });

  final String supabaseUrl;
  final String supabaseAnonKey;
  final String appName;
  final String flavor;

  static KuttiompEnvironment fromEnv(Map<String, String> env, {String? flavor}) {
    return KuttiompEnvironment(
      supabaseUrl: env['SUPABASE_URL'] ?? '',
      supabaseAnonKey: env['SUPABASE_ANON_KEY'] ?? '',
      flavor: flavor ?? env['FLAVOR'] ?? 'dev',
    );
  }

  bool get isConfigured => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Dev-mode fallback when tribal credentials are not yet configured locally.
  static KuttiompEnvironment devFallback({String flavor = 'dev'}) {
    return KuttiompEnvironment(
      supabaseUrl: 'https://placeholder.supabase.co',
      supabaseAnonKey: 'placeholder-anon-key',
      flavor: flavor,
    );
  }

  bool get isProduction => flavor == 'production' || flavor == 'prod';
}
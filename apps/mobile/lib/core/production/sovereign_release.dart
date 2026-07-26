/// Kuttiomp sovereign production release constants (v2.3.0+1).
abstract final class SovereignRelease {
  static const String version = '2.3.0+1';
  static const String codename = 'Sovereign Production Release Candidate';
  static const String statusMessage =
      'Sovereign Production-Ready | All bootstraps armed | 12 protocols green';

  static const List<String> requiredBootstrapLayers = [
    'Protocol',
    'Supabase',
    'Auth',
    'Isar',
    'Riverpod',
    'Modes',
    'Profile',
    'OfflineWorker',
    'FirstLaunch',
    'L10nElderGate',
    'Navigation',
  ];

  static bool isProductionFlavor(String? flavor) =>
      flavor == 'production' || flavor == 'prod';
}
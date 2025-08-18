enum Flavor { dev, staging, prod }

class FlavorConfig {
  final Flavor flavor;
  final String appName;
  final String apiBaseUrl;
  final bool enableLogging;
  final String appId;
  final String appVersion;
  final String buildNumber;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String appName,
    required String apiBaseUrl,
    required bool enableLogging,
    required String appId,
    required String appVersion,
    required String buildNumber,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor: flavor,
      appName: appName,
      apiBaseUrl: apiBaseUrl,
      enableLogging: enableLogging,
      appId: appId,
      appVersion: appVersion,
      buildNumber: buildNumber,
    );
    return _instance!;
  }

  FlavorConfig._internal({
    required this.flavor,
    required this.appName,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.appId,
    required this.appVersion,
    required this.buildNumber,
  });

  static FlavorConfig get instance {
    return _instance ??
        (throw Exception('FlavorConfig no ha sido inicializado'));
  }

  static bool isProduction() => _instance?.flavor == Flavor.prod;
  static bool isDevelopment() => _instance?.flavor == Flavor.dev;
  static bool isStaging() => _instance?.flavor == Flavor.staging;

  @override
  String toString() {
    return 'FlavorConfig{flavor: $flavor, appName: $appName, apiBaseUrl: $apiBaseUrl, enableLogging: $enableLogging}';
  }
}

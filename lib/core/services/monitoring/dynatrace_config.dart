import 'package:recetasperuanas/flavors/flavors_config.dart';

class DynatraceConfig {
  static DynatraceEnvironmentConfig get currentConfig {
    if (FlavorsConfig.isDev) {
      return DynatraceEnvironmentConfig.dev();
    } else if (FlavorsConfig.isStaging) {
      return DynatraceEnvironmentConfig.staging();
    } else if (FlavorsConfig.isProd) {
      return DynatraceEnvironmentConfig.prod();
    }

    return DynatraceEnvironmentConfig.dev();
  }
}

class DynatraceEnvironmentConfig {
  final String applicationId;
  final String beaconUrl;
  final bool userOptIn;
  final bool startupLoadBalancing;
  final bool startupWithGrailEnabled;
  final String environment;

  const DynatraceEnvironmentConfig({
    required this.applicationId,
    required this.beaconUrl,
    required this.userOptIn,
    required this.startupLoadBalancing,
    required this.startupWithGrailEnabled,
    required this.environment,
  });

  factory DynatraceEnvironmentConfig.dev() {
    return const DynatraceEnvironmentConfig(
      applicationId: 'dev-application-id',
      beaconUrl: 'https://dev-beacon.dynatrace.com/mbeacon',
      userOptIn: false, // Deshabilitado en desarrollo
      startupLoadBalancing: false,
      startupWithGrailEnabled: false,
      environment: 'development',
    );
  }

  /// Configuración para staging
  factory DynatraceEnvironmentConfig.staging() {
    return const DynatraceEnvironmentConfig(
      applicationId: String.fromEnvironment('DYNATRACE_APP_ID', defaultValue: 'staging-app-id'),
      beaconUrl: String.fromEnvironment(
        'DYNATRACE_BEACON_URL',
        defaultValue: 'https://staging-beacon.dynatrace.com/mbeacon',
      ),
      userOptIn: true,
      startupLoadBalancing: true,
      startupWithGrailEnabled: true,
      environment: 'staging',
    );
  }

  /// Configuración para producción
  factory DynatraceEnvironmentConfig.prod() {
    return const DynatraceEnvironmentConfig(
      applicationId: String.fromEnvironment('DYNATRACE_APP_ID', defaultValue: 'prod-app-id'),
      beaconUrl: String.fromEnvironment(
        'DYNATRACE_BEACON_URL',
        defaultValue: 'https://prod-beacon.dynatrace.com/mbeacon',
      ),
      userOptIn: true,
      startupLoadBalancing: true,
      startupWithGrailEnabled: true,
      environment: 'production',
    );
  }

  @override
  String toString() {
    return 'DynatraceEnvironmentConfig(environment: $environment, applicationId: $applicationId)';
  }
}

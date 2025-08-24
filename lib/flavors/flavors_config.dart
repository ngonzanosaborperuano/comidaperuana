enum Flavors { dev, staging, prod }

class FlavorsConfig {
  final Flavors flavor;
  final String name;
  final String baseUrl;

  static FlavorsConfig? _instance;

  FlavorsConfig._({
    required this.flavor,
    required this.name,
    required this.baseUrl,
  });

  factory FlavorsConfig({
    required Flavors flavor,
    required String name,
    required String baseUrl,
  }) {
    _instance ??= FlavorsConfig._(flavor: flavor, name: name, baseUrl: baseUrl);
    return _instance!;
  }

  static FlavorsConfig get instance {
    if (_instance == null) {
      throw Exception('FlavorsConfig not initialized');
    }
    return _instance!;
  }

  static bool get isDev => _instance?.flavor == Flavors.dev;
  static bool get isStaging => _instance?.flavor == Flavors.staging;
  static bool get isProd => _instance?.flavor == Flavors.prod;
}

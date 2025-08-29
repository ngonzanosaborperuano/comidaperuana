enum Flavors { dev, staging, prod }

class FlavorsConfig {
  final Flavors flavor;

  static FlavorsConfig? _instance;

  FlavorsConfig._({required this.flavor});

  factory FlavorsConfig({required Flavors flavor}) {
    _instance ??= FlavorsConfig._(flavor: flavor);
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

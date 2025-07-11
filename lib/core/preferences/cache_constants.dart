part of 'preferences.dart';

enum CacheConstants {
  welcome._('__welcome__'),
  darkMode._('__darkMode__'),
  spanish._('__spanish__'),
  validTime._('__validTime__'),
  autoRotation._('__autoRotation__'),
  @Deprecated('''
  Check why this exists
  ''')
  welcomeOld._('__welcomeOld__');

  const CacheConstants._(this.key);
  final String key;

  @override
  String toString() => key;
}

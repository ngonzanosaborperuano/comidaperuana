enum LoginWith {
  google._(withGoogle),
  userPassword._(withUserPassword);

  const LoginWith._(this.key);
  final int key;

  static const withGoogle = 0;
  static const withUserPassword = 1;
}

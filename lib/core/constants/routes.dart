enum Routes {
  splash._('/splash'),
  welcome._('/welcome'),
  login._('/login'),
  register._('/register'),
  home._('/home'),
  setting._('/home/setting', 'setting'),
  dashboard._('/home/dashboard','dashboard');

  const Routes._(this.description, [this.endpoint = '']);

  final String description;
  final String endpoint;
}

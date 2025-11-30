import 'package:flutter/material.dart';

import 'core/bootstrap/bootstrap.dart';

void mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
}

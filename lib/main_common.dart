import 'package:flutter/material.dart';

import 'bootstrap/bootstrap.dart';

void mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
}

import 'package:flutter/material.dart';

import 'src/shared/core/bootstrap/bootstrap.dart';

void mainCommon() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap();
}

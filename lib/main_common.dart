import 'package:flutter/material.dart';
import 'package:recetasperuanas/flavors/flavors_config.dart'
    show Flavors, FlavorsConfig;

import 'bootstrap/bootstrap.dart';

void mainCommon({
  required Flavors flavor,
  required String name,
  required String baseUrl,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorsConfig(flavor: flavor, name: name, baseUrl: baseUrl);
  await bootstrap();
}

import 'package:flutter/material.dart';

import 'bootstrap/bootstrap.dart';
import 'flavors/flavor_config.dart';

void main() async {
  final flavor = _determineFlavor();
  await mainCommon(flavor);
}

Flavor _determineFlavor() {
  return Flavor.prod;
}

Future<void> mainCommon(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrap(flavor);
}

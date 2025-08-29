import 'package:recetasperuanas/flavors/flavors_config.dart' show Flavors, FlavorsConfig;
import 'package:recetasperuanas/main_common.dart';

void main() {
  FlavorsConfig(flavor: Flavors.prod);
  mainCommon();
}

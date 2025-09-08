import 'package:recetasperuanas/main_common.dart';
import 'package:recetasperuanas/src/shared/core/config/flavors_config.dart'
    show Flavors, FlavorsConfig;

void main() {
  FlavorsConfig(flavor: Flavors.dev);
  mainCommon();
}

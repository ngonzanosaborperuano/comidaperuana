import 'package:goncook/main_common.dart';
import 'package:goncook/src/shared/core/config/flavors_config.dart' show Flavors, FlavorsConfig;

void main() {
  FlavorsConfig(flavor: Flavors.prod);
  mainCommon();
}

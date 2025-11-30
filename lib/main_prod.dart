import 'package:goncook/core/config/flavors_config.dart' show Flavors, FlavorsConfig;
import 'package:goncook/main_common.dart';

void main() {
  FlavorsConfig(flavor: Flavors.prod);
  mainCommon();
}

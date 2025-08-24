import 'package:recetasperuanas/flavors/flavors_config.dart' show Flavors;
import 'package:recetasperuanas/main_common.dart';

void main() {
  mainCommon(
    flavor: Flavors.prod,
    name: 'CookingIA',
    baseUrl: 'http://192.168.0.102:3000/api/',
  );
}

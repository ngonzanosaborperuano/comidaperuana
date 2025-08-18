import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../firebase_options.dart';
import '../../flavors/flavor_config.dart';

class FirebaseConfig {
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Configurar App Check basado en el flavor
    if (FlavorConfig.isDevelopment()) {
      // En desarrollo, usar debug provider
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );
    } else if (FlavorConfig.isStaging()) {
      // En staging, usar debug provider también
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );
    } else {
      // En producción, usar providers reales
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
        //androidProvider: AndroidProvider.playIntegrity,
        //appleProvider: AppleProvider.deviceCheck,
      );
    }
  }
}

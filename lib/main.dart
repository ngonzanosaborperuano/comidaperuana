import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/config/permission/permission.dart';
import 'package:recetasperuanas/core/database/database_helper.dart';
import 'package:recetasperuanas/core/network/api_service.dart';
import 'package:recetasperuanas/core/preferences/preferences.dart';
import 'package:recetasperuanas/core/provider/locale_provider.dart';
import 'package:recetasperuanas/core/provider/theme_provider.dart';
import 'package:recetasperuanas/core/router/app_router.dart';
import 'package:recetasperuanas/core/sync/sync_service.dart';
import 'package:recetasperuanas/firebase_options.dart';
import 'package:recetasperuanas/modules/login/controller/login_controller.dart';
import 'package:recetasperuanas/shared/repository/task_repository.dart';

import 'shared/widget/build_widget.dart';

void main() async {
  if (kDebugMode) {
    Logger.root.level = Level.ALL;
  }

  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print(record);

    if (record.error != null) {
      // ignore: avoid_print
      print('Error: ${record.error}');
      // ignore: avoid_print
      print('Stack trace: ${record.stackTrace}');
    }
  });

  // Normal errors
  FlutterError.onError = (details) {
    Logger('Flutter').severe('Flutter error', details.exception, details.stack);
  };

  // Future Unhandled errors
  PlatformDispatcher.instance.onError = (error, stack) {
    Logger('Flutter').severe('Flutter error', error, stack);
    return true;
  };
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    appleProvider:
        kDebugMode ? AppleProvider.debug : AppleProvider.appAttestWithDeviceCheckFallback,
  );

  // String? token = await FirebaseAppCheck.instance.getToken();
  // log('Token: $token');

  await dotenv.load(fileName: ".env");
  await SharedPreferencesHelper.init();
  await DatabaseHelper.init();
  final db = DatabaseHelper.instance;
  final taskRepo = TaskRepository(db, apiService: ApiService());
  final syncService = SyncService(db: db, taskRepository: taskRepo);
  syncService.startSyncObserver();
  await requestPermissions();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserRepository>(create: (_) => UserRepository(apiService: ApiService())),
        ChangeNotifierProvider(
          create:
              (_) =>
                  LoginController(userRepository: UserRepository(apiService: ApiService()))
                    ..init(context),
        ),
        ChangeNotifierProvider(create: (_) => LocaleProvider(), child: const MyApp()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child:
          Theme.of(context).platform == TargetPlatform.iOS
              ? buildiOSScreen(context, appRouter)
              : buildAndroidScreen(context, appRouter),
    );
  }
}

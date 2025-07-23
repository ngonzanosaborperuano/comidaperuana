import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:recetasperuanas/core/config/permission/permission.dart';
import 'package:recetasperuanas/core/database/database_helper.dart';
import 'package:recetasperuanas/core/preferences/preferences.dart';
//import 'package:recetasperuanas/shared/repository/task_repository.dart';
//import 'package:recetasperuanas/core/sync/sync_service.dart';
//import 'package:recetasperuanas/core/network/api_service.dart';

Future<void> initializeApp() async {
  await dotenv.load(fileName: ".env");
  await SharedPreferencesHelper.init();
  await DatabaseHelper.init();

  //final db = DatabaseHelper.instance;
  //final taskRepo = TaskRepository(db, apiService: ApiService());
  //final syncService = SyncService(db: db, taskRepository: taskRepo);
  //syncService.startSyncObserver();

  await requestPermissions();
}

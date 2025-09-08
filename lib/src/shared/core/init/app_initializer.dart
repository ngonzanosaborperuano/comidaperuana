import 'package:recetasperuanas/src/infrastructure/shared/database/database_helper.dart';
import 'package:recetasperuanas/src/shared/services/permission/permission.dart';
import 'package:recetasperuanas/src/shared/storage/preferences/preferences.dart';
//import 'package:recetasperuanas/shared/repository/task_repository.dart';
//import 'package:recetasperuanas/core/sync/sync_service.dart';
//import 'package:recetasperuanas/core/network/api_service.dart';

Future<void> initializeApp() async {
  await SharedPreferencesHelper.init();
  await DatabaseHelper.init();

  //final db = DatabaseHelper.instance;
  //final taskRepo = TaskRepository(db, apiService: ApiService());
  //final syncService = SyncService(db: db, taskRepository: taskRepo);
  //syncService.startSyncObserver();

  await requestPermissions();
}

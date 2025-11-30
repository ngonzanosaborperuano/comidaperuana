import 'package:goncook/common/services/permission/permission.dart';
import 'package:goncook/common/storage/preferences/preferences.dart';
import 'package:goncook/services/database/database_helper.dart';
//import 'package:goncook/shared/repository/task_repository.dart';
//import 'package:goncook/core/sync/sync_service.dart';
//import 'package:goncook/core/network/api_service.dart';

Future<void> initializeApp() async {
  await SharedPreferencesHelper.init();
  await DatabaseHelper.init();

  //final db = DatabaseHelper.instance;
  //final taskRepo = TaskRepository(db, apiService: ApiService());
  //final syncService = SyncService(db: db, taskRepository: taskRepo);
  //syncService.startSyncObserver();

  await requestPermissions();
}

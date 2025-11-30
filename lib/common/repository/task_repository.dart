import 'package:goncook/common/constants/storage.dart';
import 'package:goncook/common/repository/base_repository.dart';
import 'package:goncook/features/home/models/task_model.dart';
import 'package:goncook/services/database/database_helper.dart';
import 'package:goncook/services/network/api_service.dart';
import 'package:goncook/services/network/connection_observer.dart';
import 'package:logging/logging.dart';

class TaskRepository extends BaseRepository {
  TaskRepository(this.dbHelper, {required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;
  final DatabaseHelper dbHelper;

  @override
  String get name => 'TaskRepository';

  final _logger = Logger('UserRepository');

  Future<List<TaskModel>> getListTask() async {
    try {
      final taskList = await getTaskListStorage(tabla: TablaStorage.task);
      if (taskList.isEmpty || hasOneDayPassed()) {
        final result = await _apiService.getList<TaskModel>(
          endpoint: 'todos',
          fromJson: TaskModel.fromJson,
        );
        await insertTaskListStorage(result.data ?? [], nameTable: TablaStorage.task);
        await saveLastRequestDate();
        _logger.info(result.data);
        if (result.success) return result.data ?? [];
      } else {
        _logger.info('Cargando datos del storage.');
        return taskList;
      }
    } catch (e, stackTrace) {
      _logger.severe('Error: $e', e, stackTrace);
      addError(e, stackTrace);
    }
    return [];
  }

  Future<List<TaskModel>> getTaskListStorage({required String tabla}) async {
    final data = await dbHelper.queryAll(tabla);
    return data.map((item) {
      return TaskModel(
        idunique: item[ColumnsTblTask.idunique] as int,
        userId: item[ColumnsTblTask.userId] as int,
        id: item[ColumnsTblTask.id] as int? ?? 0,
        title: item[ColumnsTblTask.title],
        completed: item[ColumnsTblTask.completed] as int,
      );
    }).toList();
  }

  Future<void> insertTaskListStorage(List<TaskModel> listItems, {required String nameTable}) async {
    await dbHelper.deleteTable(nameTable);
    await Future.wait(
      listItems.map((option) {
        option.toJson().remove('idunique');
        return dbHelper.insert(nameTable, option.toJson());
      }),
    );
  }

  Future<List<TaskModel>> searchTaskListStorage({
    required String tabla,
    required String valor,
  }) async {
    final data = await dbHelper.queryByStringNew(table: tabla, valor: valor);
    return data.map((item) {
      return TaskModel(
        userId: item[ColumnsTblTask.userId] as int,
        id: item[ColumnsTblTask.id] as int,
        title: item[ColumnsTblTask.title],
        completed: item[ColumnsTblTask.completed],
      );
    }).toList();
  }

  Future<List<TaskModel>> searchCompletedStorage({
    required String tabla,
    required String valor,
  }) async {
    final data = await dbHelper.queryByString(table: tabla, valor: valor);
    return data.map((item) {
      return TaskModel(
        userId: item[ColumnsTblTask.userId] as int,
        id: item[ColumnsTblTask.id] as int,
        title: item[ColumnsTblTask.title],
        completed: item[ColumnsTblTask.completed] as int,
      );
    }).toList();
  }

  Future<bool> insertTask(TaskModel task) async {
    final hasInternet = await ConnectionObserver.instance.currentConnection;
    if (hasInternet) {
      try {
        final result = await _apiService.post(
          endpoint: 'posts',
          body: task.toJson(),
          fromJson: TaskModel.fromJson,
        );

        if (!result.success) return false;
        final item = {
          ...task.toJson(),
          ColumnsTblTask.operation: '',
          ColumnsTblTask.completed: task.toJson()[ColumnsTblTask.completed] == true ? 1 : 0,
        };
        if (task.idunique != null) {
          await dbHelper.update(data: item, table: TablaStorage.task);
        } else {
          item.remove('idunique');
          await dbHelper.insertTask(data: item, table: TablaStorage.task);
        }

        return true;
      } catch (e, stackTrace) {
        _logger.severe('Error al registrar: $e', e, stackTrace);
        addError(e, stackTrace);
        return false;
      }
    } else {
      final item = TaskModel(
        userId: task.userId,
        title: task.title,
        operation: 'insert',
        body: task.body,
        synced: 0,
        completed: 0,
        id: task.id,
      ).toJson();
      item.remove('idunique');
      final result = {
        ...item,
        ColumnsTblTask.completed: item[ColumnsTblTask.completed] == true ? 1 : 0,
      };
      await dbHelper.insertTask(data: result, table: TablaStorage.task);
      return true;
    }
  }

  Future<bool> deleteTask(int id) async {
    final hasInternet = await ConnectionObserver.instance.currentConnection;

    if (hasInternet) {
      try {
        final result = await _apiService.delete(endpoint: 'posts/$id');

        if (!result.success) return false;

        await dbHelper.deleteTask(id: id, table: TablaStorage.task);
        return true;
      } catch (e, stackTrace) {
        _logger.severe('Error al eliminar: $e', e, stackTrace);
        addError(e, stackTrace);
        return false;
      }
    } else {
      final task = TaskModel(
        id: id,
        title: '',
        synced: 0,
        operation: 'delete',
        body: '',
        userId: 0,
        completed: 0,
      ).toJson();
      task.remove('idunique');
      final item = {
        ...task,
        ColumnsTblTask.completed: task[ColumnsTblTask.completed] == true ? 1 : 0,
      };
      await dbHelper.insertTask(data: item, table: TablaStorage.task);
      return true;
    }
  }

  Future<bool> updateTask(TaskModel task) async {
    final hasInternet = await ConnectionObserver.instance.currentConnection;

    if (hasInternet) {
      try {
        final result = await _apiService.put(endpoint: 'posts/${task.id}', data: task.toJson());

        if (!result.success) return false;
        final item = {
          ...task.toJson(),
          ColumnsTblTask.operation: '',
          ColumnsTblTask.completed: task.toJson()[ColumnsTblTask.completed] == true ? 1 : 0,
        };

        await dbHelper.updateTask(data: item, table: TablaStorage.task);

        return true;
      } catch (e, stackTrace) {
        _logger.severe('Error al actualizar: $e', e, stackTrace);
        addError(e, stackTrace);
        return false;
      }
    } else {
      final result = TaskModel(
        id: task.id,
        userId: task.userId,
        title: task.title,
        operation: 'update',
        body: task.body,
        synced: 0,
        completed: task.completed ?? 0,
      ).toJson();
      final item = {
        ...result,
        ColumnsTblTask.completed: result[ColumnsTblTask.completed] == true ? 1 : 0,
      };
      item.remove('idunique');

      await dbHelper.updateTask(data: item, table: TablaStorage.task);
      return true;
    }
  }
}

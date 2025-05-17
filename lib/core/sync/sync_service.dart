import 'package:recetasperuanas/core/constants/storage.dart';
import 'package:recetasperuanas/core/database/database_helper.dart';
import 'package:recetasperuanas/core/network/connection_observer.dart';

import 'package:recetasperuanas/shared/repository/task_repository.dart';
import 'package:logging/logging.dart';

class SyncService {
  final DatabaseHelper _db;
  final TaskRepository _taskRepository;

  SyncService({
    required DatabaseHelper db,
    required TaskRepository taskRepository,
  }) : _db = db,
       _taskRepository = taskRepository;

  final _logger = Logger('SyncService');

  void startSyncObserver() {
    _logger.info('Iniciando observador de conexión...');
    ConnectionObserver.instance.onConnectionChanged.listen((isOnline) {
      _logger.info(
        'Estado de conexión detectado: ${isOnline ? "ONLINE" : "OFFLINE"}',
      );

      if (isOnline) {
        _logger.info('Conectado. Iniciando sincronización...');
        syncPendingTasks();
      }
    });
  }

  Future<void> syncPendingTasks() async {
    _logger.info('Obteniendo tareas pendientes para sincronizar...');
    final pending = await _db.getUnsyncedTasks(table: TablaStorage.task);
    _logger.info('Se encontraron ${pending.length} tareas pendientes');

    for (final task in pending) {
      _logger.info(
        'Sincronizando tarea con ID: ${task.id}, operación: ${task.operation}',
      );
      try {
        switch (task.operation) {
          case 'insert':
            await _taskRepository.insertTask(task);
            break;
          case 'update':
            await _taskRepository.updateTask(task);
            break;
          case 'delete':
            await _taskRepository.deleteTask(task.id!);
            break;
        }

        await _db.markAsSynced(
          id: task.id ?? 0,
          table: TablaStorage.task,
          data: {ColumnsTblTask.synced: 1, ColumnsTblTask.operation: ''},
        );
        _logger.info(
          'Tarea con ID ${task.idunique} - operacion: ${task.operation} sincronizada correctamente',
        );
      } catch (e, stackTrace) {
        _logger.severe(
          'Error al sincronizar tarea con ID ${task.id}',
          e,
          stackTrace,
        );
      }
    }
    pending.isEmpty
        ? ''
        : _logger.info('Sincronización completada para todas las tareas.');
  }
}

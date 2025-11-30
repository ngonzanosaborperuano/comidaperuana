import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:goncook/common/constants/storage.dart';
import 'package:goncook/services/database/database_schemas.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static DatabaseHelper get instance => _instance;

  static late Database __database;
  static Database get _database {
    if (!_isInitialized) {
      throw Exception('''
        DatabaseHelper not initialized.
        Please call DatabaseHelper.init() before using it.
      ''');
    }
    return __database;
  }

  static bool _isInitialized = false;

  static Future<void> init() async {
    try {
      final db = dotenv.env['DB']!;
      final path = join(await getDatabasesPath(), db);
      Logger('DatabaseHelper').info(path);
      __database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          for (final table in tableSchemas.values) {
            await db.execute(table);
          }
        },
        onUpgrade: (db, _, __) async {
          for (final table in tableSchemas.keys) {
            await db.execute('DROP TABLE IF EXISTS $table');
          }
          for (final table in tableSchemas.values) {
            await db.execute(table);
          }
        },
      );
      _isInitialized = true;
    } catch (error, stackTrace) {
      Logger('DatabaseHelper').severe('Error initalizing', error, stackTrace);
      _isInitialized = false;
    }
  }

  Future<int> deleteTable(String table) async {
    return _database.delete(table);
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final result = {
      ...data,
      ColumnsTblTask.completed: data[ColumnsTblTask.completed] == true ? 1 : 0,
    };

    return _database.insert(table, result);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    return await _database.query(table);
  }

  Future<List<Map<String, dynamic>>> queryByString({
    required String table,
    required String valor,
  }) async {
    final result = await _database.query(table, where: 'completed = ?', whereArgs: [valor]);
    return result;
  }

  Future<List<Map<String, dynamic>>> queryByStringNew({
    required String table,
    required String valor,
  }) async {
    final result = await _database.query(table, where: 'title LIKE ?', whereArgs: ['%$valor%']);
    return result;
  }

  Future<void> insertTask({required Map<String, dynamic> data, required String table}) async {
    await _database.insert(table, data);
  }

  Future<void> updateTask({required Map<String, dynamic> data, required String table}) async {
    await _database.update(table, data, where: 'id = ?', whereArgs: [data['id']]);
  }

  Future<void> update({required Map<String, dynamic> data, required String table}) async {
    await _database.update(table, data, where: 'idunique = ?', whereArgs: [data['idunique']]);
  }

  Future<void> deleteTask({required int id, required String table}) async {
    await _database.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> delete({required int unique, required String table}) async {
    await _database.delete(table, where: 'idunique = ?', whereArgs: [unique]);
  }
}

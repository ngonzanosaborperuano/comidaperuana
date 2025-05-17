import 'package:recetasperuanas/core/constants/storage.dart';

final Map<String, String> tableSchemas = {
  TablaStorage.task: '''
    CREATE TABLE ${TablaStorage.task} (
    ${ColumnsTblTask.idunique} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    ${ColumnsTblTask.id} INTEGER NULL,
    ${ColumnsTblTask.userId} INTEGER NOT NULL,
    ${ColumnsTblTask.title} TEXT NOT NULL,
    ${ColumnsTblTask.body} TEXT NULL,
    ${ColumnsTblTask.completed} INTEGER NOT NULL,
    ${ColumnsTblTask.synced} INTEGER DEFAULT 1,
    ${ColumnsTblTask.operation} TEXT DEFAULT ''
    );
  ''',
};

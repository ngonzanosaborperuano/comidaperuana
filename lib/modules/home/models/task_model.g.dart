// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
  userId: (json['user_id'] as num).toInt(),
  id: (json['id'] as num?)?.toInt(),
  completed: boolIntConverter.fromJson(json['completed']),
  title: json['title'] as String,
  body: json['body'] as String?,
  operation: json['operation'] as String?,
  synced: (json['synced'] as num?)?.toInt(),
  idunique: (json['idunique'] as num?)?.toInt(),
);

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
  if (instance.idunique case final value?) 'idunique': value,
  'user_id': instance.userId,
  if (instance.id case final value?) 'id': value,
  if (instance.synced case final value?) 'synced': value,
  'title': instance.title,
  if (instance.operation case final value?) 'operation': value,
  if (instance.body case final value?) 'body': value,
  if (boolIntConverter.toJson(instance.completed) case final value?)
    'completed': value,
};

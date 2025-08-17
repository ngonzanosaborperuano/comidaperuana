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
  'idunique': ?instance.idunique,
  'user_id': instance.userId,
  'id': ?instance.id,
  'synced': ?instance.synced,
  'title': instance.title,
  'operation': ?instance.operation,
  'body': ?instance.body,
  'completed': ?boolIntConverter.toJson(instance.completed),
};

import 'package:equatable/equatable.dart';
import 'package:recetasperuanas/shared/utils/converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel extends Equatable {
  const TaskModel({
    required this.userId,
    this.id,
    this.completed,
    required this.title,
    this.body,
    this.operation,
    this.synced,
    this.idunique,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
  final int? idunique;
  final int userId;
  final int? id;
  final int? synced;
  final String title;
  final String? operation;
  final String? body;

  @boolIntConverter
  final int? completed;

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  static const TaskModel empty = TaskModel(
    idunique: 0,
    id: 0,
    userId: 0,
    title: '',
    completed: 0,
    body: '',
    operation: '',
    synced: 0,
  );

  @override
  List<Object?> get props => [
    idunique,
    id,
    userId,
    completed,
    title,
    body,
    synced,
    operation,
  ];
}

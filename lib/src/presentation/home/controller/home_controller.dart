import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:goncook/src/domain/auth/repositories/i_user_repository.dart';
import 'package:goncook/src/presentation/home/models/task_model.dart';
import 'package:goncook/src/shared/constants/storage.dart';
import 'package:goncook/src/shared/controller/base_controller.dart';
import 'package:goncook/src/shared/repository/task_repository.dart';
import 'package:goncook/src/shared/storage/secure_storage/securete_storage_service.dart';

class HomeController extends BaseController {
  HomeController({required IUserRepository userRepository, required TaskRepository taskRepository})
    : _userRepository = userRepository,
      _taskRepository = taskRepository;
  @override
  String get name => 'HomeController';

  final IUserRepository _userRepository;
  final TaskRepository _taskRepository;

  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  ISecureStorageService secureStorageService = SecurityStorageService();

  List<TaskModel> listTask = [];
  List<TaskModel> listTaskDashboard = [];
  Timer? _debounce;

  final isPending = ValueNotifier<bool?>(null);

  // Future<void> runFeatureFlagFlow(String prompt) async {
  //   final configService = RemoteConfigService();
  //   await configService.initialize();

  //   final aiService = GeminiAIService(configService);
  //   await aiService.generateAudioText(prompt: prompt);
  // }

  Future<void> allRecipes() async {
    listTask = await _taskRepository.getListTask();
    listTaskDashboard = listTask;
    notifyListeners();
  }

  Future<void> searchCompleted() async {
    listTask = await _taskRepository.searchCompletedStorage(
      tabla: TablaStorage.task,
      valor: isPending.value != true ? '1' : '0',
    );
    notifyListeners();
  }

  Future<bool> insertTask() async {
    final user = await secureStorageService.loadCredentials();
    final taskModel = TaskModel(
      userId: user!.id!,
      title: titleController.text,
      body: bodyController.text,
    );
    final result = await _taskRepository.insertTask(taskModel);
    return result;
  }

  Future<bool> updateTask(int id) async {
    final user = await secureStorageService.loadCredentials();
    final taskModel = TaskModel(
      userId: user!.id!,
      id: id,
      title: titleController.text,
      body: bodyController.text,
    );

    final result = await _taskRepository.updateTask(taskModel);
    return result;
  }

  Future<bool> deleteTask(int id) async {
    final result = await _taskRepository.deleteTask(id);
    return result;
  }

  void searchTask(String title) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      listTask = await _taskRepository.searchTaskListStorage(
        tabla: TablaStorage.task,
        valor: title,
      );
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:recetasperuanas/core/auth/repository/user_repository.dart';
import 'package:recetasperuanas/core/constants/storage.dart';
import 'package:recetasperuanas/core/secure_storage/securete_storage_service.dart';
import 'package:recetasperuanas/modules/home/models/task_model.dart';
import 'package:recetasperuanas/shared/controller/base_controller.dart';
import 'package:recetasperuanas/shared/repository/task_repository.dart';

class HomeController extends BaseController {
  HomeController({
    required UserRepository userRepository,
    required TaskRepository taskRepository,
  }) : _userRepository = userRepository,
       _taskRepository = taskRepository;
  @override
  String get name => 'HomeController';

  final UserRepository _userRepository;
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

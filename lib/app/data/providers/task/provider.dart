import 'dart:convert';

import 'package:get/get.dart';
import 'package:saeng_app/app/core/utils/keys.dart';

import '../../services/storage/models/task.dart';
import '../../services/storage/services.dart';

class TaskProvider {
  final StorageService _storage = Get.find<StorageService>();

  List<Task> readTasks() {
    var tasks = <Task>[];
    jsonDecode(_storage.read(taskKey).toString()).forEach(
      (element) => tasks.add(Task.fromJson(element)),
    );
    return tasks;
  } //

  void writeTasks(List<Task> tasks) {
    _storage.write(taskKey, jsonEncode(tasks));
  }
}

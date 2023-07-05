//reposiitory를 통해 provider에 접근할 수 있음
import 'package:saeng_app/app/data/models/task.dart';

import '../../providers/task/provider.dart';

class TaskRepository {
  TaskProvider taskProvider;
  TaskRepository({
    required this.taskProvider,
  });

  List<Task> readTasks() => taskProvider.readTasks();
  void writeTasks(List<Task> tasks) => taskProvider.writeTasks(tasks);
}

//model 과 provider 을 이어주는 repository

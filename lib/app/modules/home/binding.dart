import 'package:get/get.dart';
import 'package:saeng_app/app/data/providers/task/provider.dart';
import 'package:saeng_app/app/data/services/storage/reporsitory.dart';
import 'package:saeng_app/app/modules/home/controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        taskRepository: TaskRepository(
          taskProvider: TaskProvider(),
        ),
      ),
    );
  }
}

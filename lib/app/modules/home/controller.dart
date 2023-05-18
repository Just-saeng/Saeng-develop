import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saeng_app/app/data/services/storage/models/task.dart';
import 'package:saeng_app/app/data/services/storage/reporsitory.dart';

//formKey: FormState를 관리하기 위한 GlobalKey입니다.
//taskRepository: 외부 데이터 액세스를 위한 TaskRepository 객체입니다.
//formEditCtrl: 텍스트 입력 폼을 관리하기 위한 TextEditingController 객체입니다.
//tabIndex: 현재 선택된 탭의 인덱스를 관리하기 위한 Rx<int> 객체입니다.
//chipIndex: 현재 선택된 칩의 인덱스를 관리하기 위한 Rx<int> 객체입니다.
//deleting: 삭제 중인지 여부를 관리하기 위한 Rx<bool> 객체입니다.
//tasks: 작업 목록을 관리하기 위한 RxList<Task> 객체입니다.
//task: 선택된 작업을 관리하기 위한 Rx<Task?> 객체입니다.
//doingTodos: 진행 중인 할 일들을 관리하기 위한 RxList<dynamic> 객체입니다.
//doneTodos: 완료된 할 일들을 관리하기 위한 RxList<dynamic> 객체입니다.
//HomeController 클래스는 다음과 같은 메서드들을 제공합니다:
//
//onInit(): GetxController의 라이프사이클 메서드로, 초기화 작업을 수행합니다. 여기서는 taskRepository를 사용하여 작업 목록을 읽어와 tasks에 할당하고, tasks가 변경될 때마다 변경 내용을 taskRepository에 저장하는 로직을 설정합니다.
//onClose(): GetxController의 라이프사이클 메서드로, 컨트롤러가 소멸될 때 호출됩니다. 여기서는 formEditCtrl를 정리합니다.
//addTask(): 새로운 작업을 추가하는 메서드입니다. 이미 작업 목록에 해당 작업이 있는 경우 추가하지 않고, 성공적으로 추가된 경우 true를 반환합니다.
//deleteTask(): 작업을 삭제하는 메서드입니다.
//updateTask(): 작업의 제목을 업데이트하는 메서드입니다. 해당 작업에 중복된 제목의 할 일이 있는 경우 업데이트를 취소하고, 성공적으로 업데이트된 경우 true를 반환합니다.
//containTodo(): 할 일 목록에 중복된 제목의 할 일이 있는지 확인하는 메서드입니다.
//changeChipIndex(): 현재 선택된 칩의 인덱스를 변경하는 메서드입니다.
//changeDeleting(): 삭제 중인지 여부를 변경하는 메서드입니다.
//changeTask(): 선택된 작업을 변경하는 메서드입니다.
//changeTodo(): 선택된 할 일 목록을 변경하는 메서드입니다.
//addTodo(): 할 일을 추가하는 메서드입니다. 이미 진행 중인 할 일 또는 완료된 할 일 목록에 해당 할 일이 있는 경우 추가하지 않고, 성공적으로 추가된 경우 true를 반환합니다.
//updateTodo(): 할 일 목록을 업데이트하는 메서드입니다.
//doneTodo(): 할 일을 완료 상태로 변경하는 메서드입니다.
//deleteDoneTodo(): 완료된 할 일을 삭제하는 메서드입니다.
//isTodoEmpty(): 작업의 할 일 목록이 비어있는지 확인하는 메서드입니다.
//getDoneTodo(): 작업의 완료된 할 일 개수를 반환하는 메서드입니다.
//changeTabIndex(): 현재 선택된 탭의 인덱스를 변경하는 메서드입니다.
//getTotalTask(): 모든 작업의 할 일 개수를 반환하는 메서드입니다.
//getTotalDoneTask(): 모든 작업 중 완료된 할 일 개수를 반환하는 메서드입니다.

class HomeController extends GetxController {
  final formKey = GlobalKey<FormState>(); //폼 상태를 관리하기 위함
  TaskRepository taskRepository;
  HomeController({
    required this.taskRepository,
  });

  final formEditCtrl = TextEditingController(); //텍스트 입력 폼을 관리하기 위함
  final tabIndex = 0.obs; //선택된 탭의 인덱스를 관리하기 위한 반응형 변수
  final chipIndex = 0.obs; //현재 선택된 칩의 인덱스를 관리하는 반응형 변수
  final deleting = false.obs; //bool 타입, 삭제 중인지 여부를 관리함
  final tasks = <Task>[].obs; //작업 목록을 관리하는 반응형 리스트
  final task = Rx<Task?>(null); //선택된 작업을 관리하는 반응형 변수(초기값: null)
  final doingTodos = <dynamic>[].obs; //진행중인 할 일과 완료된 할 일 목록 관리
  final doneTodos = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks()); //초기화 작업: 작업목록 읽어와 tasks에 할당
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  } //tasks가 변경될 때 마다 변경내용 taskRepository에 저장

  @override
  void onClose() {
    // TODO: implement onClose
    formEditCtrl.dispose();
    super.onClose();
  } // formEditCtrl을 컨트롤러가 소멸될 때 정리함

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }
    tasks.add(task);
    return true;
  } // 이미 작업 목록에 해당 작업이 있는 경우 추가 안하고, 성공적으로 추가시 true 반환

  void deleteTask(Task task) {
    tasks.remove(task);
  } // 주어진 작업을 작업 목록에서 제거

  updateTask(Task task, String title) {
    var todos = task.todos ?? [];
    if (containTodo(todos, title)) {
      return false;
    } //중복된 제목이 있으면 업데이트 취소
    var todo = {'title': title, 'done': false};
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldIdx = tasks.indexOf(task);
    tasks[oldIdx] = newTask;
    tasks.refresh();
    return true;
  } // 작업의 제목을 업데이트함, 성공시 true 반환

  bool containTodo(List todos, String title) {
    return todos.any((element) => element['title'] == title);
  } //중복된 제목의 할 일이 있는지 확인 하나라도 있으면 true 반환

  void changeChipIndex(int value) {
    chipIndex.value = value;
  } //선택된 칩의 인덱스 변경, value 값을 chipIndex 에 할당

  void changeDeleting(bool value) {
    deleting.value = value;
  } //삭제중인지 확인 value 값을 deleting에 할당

  void changeTask(Task? select) {
    task.value = select;
  } //주어진 select의 값을 task에 할당해 선택된 작업을 변경함

  void changeTodo(List<dynamic> select) {
    doneTodos.clear();
    doingTodos.clear();

    for (var i = 0; i < select.length; i++) {
      var todo = select[i];
      var status = todo['done'];
      if (status == true) {
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  } //할일 목록 변경 select를 순회하면서 완료된 일과 진행중인 걸 나우어 각각에 저장

  bool addTodo(String title) {
    var doingTodo = {'title': title, 'done': false};
    if (doingTodos
        .any((element) => mapEquals<String, dynamic>(doingTodo, element))) {
      return false;
    }
    var doneTodo = {'title': title, 'done': true};
    if (doneTodos
        .any((element) => mapEquals<String, dynamic>(doneTodo, element))) {
      return false;
    }
    doingTodos.add(doingTodo);
    return true;
  }

  void updateTodo() {
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([
      ...doingTodos,
      ...doneTodos,
    ]);
    var newTask = task.value!.copyWith(todos: newTodos);
    int oldIdx = tasks.indexOf(task.value);
    tasks[oldIdx] = newTask;
    tasks.refresh();
  }

  void doneTodo(String title) {
    var doingTodo = {'title': title, 'done': false};
    int index = doingTodos.indexWhere(
        (element) => mapEquals<String, dynamic>(doingTodo, element));
    doingTodos.removeAt(index);
    var doneTodo = {'title': title, 'done': true};
    doneTodos.add(doneTodo);
    doingTodos.refresh();
    doneTodos.refresh();
  }

  deleteDoneTodo(dynamic doneTodo) {
    int index = doneTodos
        .indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element));
    doneTodos.removeAt(index);
    doneTodos.refresh();
  }

  bool isTodoEmpty(Task task) {
    return task.todos == null || task.todos!.isEmpty;
  }

  int getDoneTodo(Task task) {
    var res = 0;
    for (int i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done'] == true) {
        res += 1;
      }
    }
    return res;
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  int getTotalTask() {
    var res = 0;
    for (var i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        res += tasks[i].todos!.length;
      }
    }
    return res;
  }

  int getTotalDoneTask() {
    int res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        for (int j = 0; j < tasks[i].todos!.length; j++) {
          // if (j < 0 || j >= tasks[i].todos!.length) break;
          if (tasks[i].todos![j]['done'] == true) {
            res += 1;
          }
        }
      }
    }
    return res;
  }
}

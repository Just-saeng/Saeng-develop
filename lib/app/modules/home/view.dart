import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:saeng_app/app/core/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:saeng_app/app/core/values/colors.dart';
import 'package:saeng_app/app/data/models/task.dart';
import 'package:saeng_app/app/modules/home/controller.dart';
import 'package:saeng_app/app/modules/home/widgets/add_card.dart';
import 'package:saeng_app/app/modules/home/widgets/task_card.dart';

class Homepage extends GetView<HomeController> {
  const Homepage({super.key}); // 홈페이지의 상태 관리 HomeController 와 연결됨

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(index: controller.tabIndex.value, children: [
          //IndexedStack 위젯으로 여러개의 자식 위젯 중에서 현재 선택된 탭에 해당하는 위젯을 표시한다. index는 현재 선택된 탭의 인덱스를 나타낸다
          SafeArea(
            //화면 경계를 벗어나지 않도록 도와줌
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(4.0.wp),
                  child: Text(
                    'My List',
                    style: TextStyle(
                      fontSize: 24.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Obx(
                  () => GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true, // 크기를 자동으로 조정해도 ㄱㄴ
                    physics: const ClampingScrollPhysics(),
                    children: [
                      ...controller.tasks.map((element) => LongPressDraggable(
                          data: element,
                          onDragStarted: () => controller.changeDeleting(true),
                          onDraggableCanceled: (velocity, offset) =>
                              controller.changeDeleting(false),
                          onDragEnd: (details) =>
                              controller.changeDeleting(false),
                          feedback: Opacity(
                            opacity: 0.5,
                            child: TaskCard(task: element),
                          ),
                          child: TaskCard(task: element))),
                      AddCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //ReportPage()
        ]),
      ),
      floatingActionButton: DragTarget<Task>(
        builder: (_, __, ____) {
          return Obx(
            () => FloatingActionButton(
              onPressed: () {
                if (controller.tasks.isNotEmpty) {
                  //Get.to(() => AddDialog(), transition: Transition.downToUp);
                } else {
                  EasyLoading.showInfo('Please create task first..');
                }
              },
              backgroundColor:
                  controller.deleting.value ? Colors.red : darkGreen,
              child: Icon(controller.deleting.value ? Icons.delete : Icons.add),
            ),
          );
        },
        onAccept: (Task task) {
          controller.deleteTask(task);
          EasyLoading.showSuccess('Deleted');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Obx(
          () => BottomNavigationBar(
            onTap: (int index) => controller.changeTabIndex(index),
            currentIndex: controller.tabIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: darkGreen,
            items: const [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.apps),
              ),
              BottomNavigationBarItem(
                label: 'Report',
                icon: Icon(Icons.data_usage),
              )
            ],
          ),
        ),
      ),
    );
  }
}

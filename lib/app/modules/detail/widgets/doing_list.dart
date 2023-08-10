import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saeng_app/app/core/utils/extensions.dart';
import 'package:saeng_app/app/modules/home/controller.dart';

class DoingList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DoingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => homeCtrl.doingTodos.isEmpty && homeCtrl.doneTodos.isEmpty
        ? Column(
            children: [
              Text(
                'Add Saeng!',
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0.sp,
                ),
              )
            ],
          )
        : ListView(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            children: [
              ...homeCtrl.doingTodos
                  .map(
                    (element) => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.0.wp, //체크박스 앞쪽 공백
                        vertical: 3.0.wp, //체크박스간의 위아래 간격
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              fillColor: MaterialStateProperty.resolveWith(
                                  (states) => Colors.grey),
                              value: element['done'],
                              onChanged: (value) {
                                homeCtrl.doneTodo(element['title']);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
                            child: Text(
                              element['title'],
                              overflow:
                                  TextOverflow.ellipsis, //텍스트가 길어서 넘치면 자르기(...)
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(), // homeCtrl.doingTodos을 .map과 .toList로 리스트 형태로 변환하여 리스트뷰를 쓸 수 있도록함
              if (homeCtrl.doingTodos.isNotEmpty) //리스트가 비어있지 않다면
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                  child: const Divider(
                    // 구분선 코드
                    thickness: 2,
                  ),
                )
            ],
          ));
  }
}

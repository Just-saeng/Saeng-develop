import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saeng_app/app/core/utils/extensions.dart';
import 'package:saeng_app/app/core/values/colors.dart';
import 'package:saeng_app/app/modules/home/controller.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          // *------------------------리포트페이지 ui전에 계산들
          var createdTasks = homeCtrl.getTotalTask();
          int completedTasks = homeCtrl.getTotalDoneTask(); //?---완료된 값
          var liveTasks = createdTasks - completedTasks; //?----남아있는 것 계산
          var percent = (completedTasks / createdTasks * 100)
              .toStringAsFixed(0); //?----만든 것 중에서 해결한 것의 백분율
          return ListView(
            //*-------------------------여기서 부터 ui
            children: [
              Padding(
                // ?---리포트 페이지 제목
                padding: EdgeInsets.all(4.0.wp),
                child: Text(
                  'My Report',
                  style: TextStyle(
                    fontSize: 24.0.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                //?---그 밑에 날짜
                padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
                child: Text(
                  DateFormat.yMMMd().format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 14.0.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                // ?---구분선
                padding: EdgeInsets.symmetric(
                  vertical: 3.0.wp,
                  horizontal: 4.0.wp,
                ),
                child: const Divider(
                  thickness: 2,
                ),
              ),
              Padding(
                //?---live, completed, created 갯수
                padding: EdgeInsets.symmetric(
                  vertical: 3.0.wp,
                  horizontal: 5.0.wp,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatus(
                      Colors.green,
                      liveTasks,
                      'Live Tasks',
                    ),
                    _buildStatus(
                      Colors.orange,
                      completedTasks,
                      'Completed',
                    ),
                    _buildStatus(
                      Colors.blue,
                      createdTasks,
                      'Created',
                    ),
                  ],
                ),
              ),
              SizedBox(
                //?---공백
                height: 8.0.wp,
              ),
              UnconstrainedBox(
                //^자식 부모 위젯의 제한을 무시하고 원래 크기대로 표시 될 수 있음
                child: SizedBox(
                  width: 70.0.wp,
                  height: 70.0.wp,
                  child: CircularStepProgressIndicator(
                    totalSteps: createdTasks == 0 ? 1 : createdTasks,
                    currentStep: completedTasks,
                    stepSize: 20,
                    selectedColor: purple,
                    unselectedColor: Colors.grey[200],
                    padding: 0,
                    width: 150,
                    height: 150,
                    selectedStepSize: 22,
                    roundedCap: (_, __) => true,
                    child: Column(
                      //?---원안에 텍스트: 퍼센테이지, 효율
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${createdTasks == 0 ? 0 : percent}%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0.sp,
                          ),
                        ),
                        SizedBox(
                          height: 1.0.wp,
                        ),
                        Text(
                          'Efficiency',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 12.0.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Padding _buildStatus(Color color, int number, String title) {
    //?---buildstatus함수 정의
    return Padding(
      padding: EdgeInsets.only(left: 3.0.wp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 3.0.wp,
            width: 3.0.wp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 0.5.wp,
                color: color,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$number',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0.sp,
                ),
              ),
              SizedBox(
                height: 2.0.wp,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.0.sp,
                  color: Colors.grey,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:saeng_app/app/core/utils/extensions.dart';
import 'package:saeng_app/app/core/values/colors.dart';
import 'package:saeng_app/app/data/models/task.dart';
import 'package:saeng_app/app/modules/home/controller.dart';
import 'package:saeng_app/app/widgets/icons.dart';

class AddCard extends StatelessWidget {
  final homeCtrl =
      Get.find<HomeController>(); //get패키지를 사용하여 HomeController인스턴스를 찾아옴
  AddCard({super.key}); //super.key는 상위클래스의 생성자에 전달되는 값
  //key는 위젯의 고유 식별자로 사용

  @override
  Widget build(BuildContext context) {
    //build메서드는 위젯을 생성 반환한다
    final icons = getIcons(); //icons.dart로 부터 아이콘을 가져옴
    var cardWidth =
        Get.width - 12.0.wp; //get.width는 현재 화면의 넓이 이고 이를 통해 cardWidth를 정한다
    return Container(
      //컨테이너로cardwidth를 2로 나눈 만틈의 사각형 영역을 씀
      width: cardWidth / 2,
      height: cardWidth / 2,
      margin: EdgeInsets.all(3.0.wp),
      child: InkWell(
        //InkWell로 터치 가능한 영역을 생성함
        onTap: () async {
          //onTap으로 터치 이벤트를 처리함
          await Get.defaultDialog(
              //defaultDialog로 대화상자를 표시 제목, 등 다양한 형식 사용자맘대로 꾸밀 수 있음
              titlePadding: EdgeInsets.symmetric(vertical: 5.0.wp),
              radius: 10,
              title: 'Task Type',
              content: Form(
                //form 위젯으로 다양한 위젯들을 자식으로 가지고 묶을 수 있다
                key: homeCtrl.formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                      child: TextFormField(
                        // 또 하나의 위젯을 포함하고 있는 form, 작업 제목을 입력하는데 쓰여진다
                        controller: homeCtrl.formEditCtrl,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Title',
                        ),
                        validator: (value) {
                          // validator : TextFormField 에서 제공되는 속성 중 하나이다. value는 입력된 값
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your task title';
                          }
                          return null; //유효성 검사
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0.wp),
                      child: Wrap(
                        //Wrap 위젯은 자식 위젯을 행 또는 열로 자동으로 래핑함
                        spacing: 2.0.wp,
                        children: icons
                            .map(
                              (element) => Obx(
                                // element 는 icons의 요소들
                                () {
                                  final index = icons.indexOf(
                                      element); //icons의 요소로 index를 정하는 것
                                  return ChoiceChip(
                                    selectedColor: Colors.grey[200],
                                    pressElevation: 4, //칩이 눌릴 때 적용되는 표면의 고도
                                    backgroundColor: Colors.white, //배경색
                                    label: element, // 칩에 표시될 레이블
                                    selected: homeCtrl.chipIndex.value ==
                                        index, //칩의 선택 상태
                                    onSelected: (bool selected) {
                                      homeCtrl.chipIndex
                                              .value = //칩이 선택되었을 때 호출되는 콜백함수이다.
                                          selected
                                              ? index
                                              : 0; // 칩이 선택 해제 된경우 0 으로 설정
                                    },
                                  );
                                },
                              ),
                            )
                            .toList(), //map 메소드 안에 과정을 거친후 tolist로 list로 반환 단순히 메모리에 잠시 머물기만 함. 딱히 쓸모 없음
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: const Size(150, 40),
                      ),
                      onPressed: () {
                        if (homeCtrl.formKey.currentState!.validate()) {
                          int icon =
                              icons[homeCtrl.chipIndex.value].icon!.codePoint;
                          String color =
                              icons[homeCtrl.chipIndex.value].color!.toHex();
                          var task = Task(
                              title: homeCtrl.formEditCtrl.text,
                              icon: icon,
                              color: color);
                          Get.back();
                          homeCtrl.addTask(task)
                              ? EasyLoading.showSuccess('Task Created')
                              : EasyLoading.showError('Task Already Exists');

                          homeCtrl.formEditCtrl.clear();
                          homeCtrl.changeChipIndex(0);
                        }
                      },
                      child: const Text("Confirm"),
                    )
                  ],
                ),
              ));
          homeCtrl.formEditCtrl.clear();
          homeCtrl.changeChipIndex(0);
        },
        child: DottedBorder(
          color: Colors.grey[400]!,
          dashPattern: const [10, 8],
          child: Center(
            child: Icon(
              Icons.add,
              size: 10.0.wp,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:saeng_app/app/core/utils/extensions.dart';
import 'package:get/get.dart';
import 'package:saeng_app/app/modules/home/controller.dart';
import 'package:saeng_app/app/modules/home/widgets/add_card.dart';

class Homepage extends GetView<HomeController> {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
            GridView.count(
              // Gridview 는 listview 와 달리 2차원이다 갤러리 사진 정렬 형태
              crossAxisCount: 2, //그리드의 열(가로) 수를 지정한다
              shrinkWrap: true, // 크기를 자동으로 자식 요소에 맞게 조정
              physics: const ClampingScrollPhysics(), //스크롤 가능한 경계를 지정
              children: [AddCard()],
            ),
          ],
        ),
      ),
    );
  }
}

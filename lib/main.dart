import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saeng_app/app/data/services/storage/services.dart';
import 'package:saeng_app/app/modules/home/binding.dart';
import 'package:saeng_app/app/modules/home/view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  await GetStorage.init();
  await Get.putAsync(() => StorageService().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(fontFamily: 'Pretendard'),
      themeMode: ThemeMode.system,
      title: 'Todo List using GetX',
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
      initialBinding: HomeBinding(),
      builder: EasyLoading.init(),
    );
  }
}

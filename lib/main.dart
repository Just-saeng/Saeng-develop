import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saeng_app/app/data/services/storage/services.dart';
import 'package:saeng_app/app/modules/home/view.dart';
import 'package:get_storage/get_storage.dart';

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
    return const GetMaterialApp(
      title: 'Todo List using GetX',
      home: Homepage(),
    );
  }
}

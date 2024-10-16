import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:samsisegi/diary_data/diary_entry.dart';

import 'package:samsisegi/nick_name_setting.dart';

void main() async {
  //Hive 초기화
  await Hive.initFlutter();
  //DiaryEntry 어댑터 등록
  Hive.registerAdapter(DiaryEntryAdapter());
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => const NickNameSetting(),
    );
  }
}

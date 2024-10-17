import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:samsisegi/diary_data/diary_entry.dart';
import 'package:samsisegi/nick_name_setting.dart';
import 'package:samsisegi/home_screen/home_screen.dart'; // 홈 화면 추가 예시

void main() async {
  // Hive 초기화
  await Hive.initFlutter();
  // DiaryEntry 어댑터 등록
  Hive.registerAdapter(DiaryEntryAdapter());
  runApp(MyApp());
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
      builder: (context, child) => MaterialApp(
        initialRoute: NickNameSetting.routeName, // 초기 루트 설정
        routes: {
          NickNameSetting.routeName: (context) =>
              const NickNameSetting(), // 닉네임 설정 화면
          HomeScreen.routeName: (context) => const HomeScreen(), // 홈 화면
        },
      ),
    );
  }
}

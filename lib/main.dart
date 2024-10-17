import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:samsisegi/diary_data/diary_entry.dart';
import 'package:samsisegi/home_screen/home_screen.dart';
import 'package:samsisegi/nick_name_setting.dart';
import 'package:samsisegi/home_screen/home_contents.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 홈 화면 추가 예시

void main() async {
  // Hive 초기화
  await Hive.initFlutter();
  // DiaryEntry 어댑터 등록
  Hive.registerAdapter(DiaryEntryAdapter());

  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? nickname = prefs.getString('nickName');

  runApp(
    MyApp(
        initialRoute: nickname == null
            ? NickNameSetting.routeName
            : HomeScreen.routeName),
  );
}

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

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
        navigatorObservers: [routeObserver],
        routes: {
          NickNameSetting.routeName: (context) =>
              const NickNameSetting(), // 닉네임 설정 화면
          HomeContents.routeName: (context) => const HomeScreen(), // 홈 화면
        },
      ),
    );
  }
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

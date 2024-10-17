import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:samsisegi/design_system.dart';
import 'package:samsisegi/home_screen/data_section.dart';
import 'package:samsisegi/home_screen/diary_manager.dart';
import 'package:samsisegi/write_diary/select_emotions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom_component/custom_bottom_navigation_bar.dart';
import '../custom_component/empty_home_content.dart';
import '../custom_component/home_content.dart';
import '../diary_data/diary_entry.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? nickName = '';
  int _currentIndex = 0;
  DateTime currentDate = DateTime.now();
  Map<String, DiaryEntry?> entries = {};

  @override
  void initState() {
    super.initState();
    _loadNickName();
    _loadDiaryEntries();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadDiaryEntries();
  }

  // 닉네임 불러오기 함수
  void _loadNickName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nickName = prefs.getString('nickName') ?? '무명의 기록자';
    });
  }

  Future<void> _loadDiaryEntries() async {
    entries = await DiaryManager.loadEntries(currentDate); // 분리된 로직 호출
    setState(() {});
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) {
      _refreshCurrentPage();
    } else {
      setState(() {
        _currentIndex = index;
      });

      // 페이지 이동 처리
      // 페이지 이동 관련 로직은 기존대로 유지
    }
  }

  void _refreshCurrentPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color morningColor = getTimeColor(5, 24);
    Color afternoonColor = getTimeColor(12, 24);
    Color nightColor = getTimeColor(18, 24);

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          setState(
              () => currentDate = currentDate.add(const Duration(days: 1)));
          _loadDiaryEntries();
        } else if (details.primaryVelocity! > 0) {
          setState(() =>
              currentDate = currentDate.subtract(const Duration(days: 1)));
          _loadDiaryEntries();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              _buildDivider(),
              SizedBox(height: 40.h),
              DateSection(currentDate: currentDate), // 날짜 섹션 컴포넌트로 분리
              SizedBox(height: 40.h),
              _buildHomeContent('morning', "오늘 아침은 어땠나요?", "朝 |", morningColor),
              SizedBox(height: 16.h),
              _buildHomeContent(
                  'afternoon', "오늘 오후는 어땠나요?", "午 |", afternoonColor),
              SizedBox(height: 16.h),
              _buildHomeContent('night', "오늘 저녁/밤은 어땠나요?", "夜 |", nightColor),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            Text("안녕하세요,", style: TextStyle(fontWeight: FontWeight.w300)),
            SizedBox(width: 2.w),
            Text('$nickName님', style: TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Divider _buildDivider() => Divider(color: Colors.black, height: 1.h);

  Widget _buildHomeContent(
      String period, String contentText, String timeText, Color timeColor) {
    final entry = entries[period];
    if (entry != null) {
      return HomeContent(
          timeText: timeText,
          titleText: entry.title,
          contentText: entry.content);
    } else {
      return EmptyHomeContent(
        timeText: timeText,
        contentText: contentText,
        timeColor: timeColor,
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => SelectEmotions(
                    date: DateFormat('yyyy-MM-dd').format(currentDate),
                    period: period)),
          );
        },
      );
    }
  }

  Color getTimeColor(int startHour, int endHour) {
    DateTime now = DateTime.now();
    DateTime selectedDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    if (selectedDate.isBefore(DateTime(now.year, now.month, now.day))) {
      return AppColors.primary;
    } else if (selectedDate.isAfter(DateTime(now.year, now.month, now.day))) {
      return AppColors.gray;
    } else {
      int currentHour = now.hour;
      return currentHour >= startHour && currentHour < endHour
          ? AppColors.primary
          : AppColors.gray;
    }
  }
}

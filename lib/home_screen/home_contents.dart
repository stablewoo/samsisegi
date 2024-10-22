import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:samsisegi/design_system.dart';
import 'package:samsisegi/diary_data/diary_cache.dart';
import 'package:samsisegi/home_screen/data_section.dart';
import 'package:samsisegi/home_screen/diary_manager.dart';
import 'package:samsisegi/main.dart';
import 'package:samsisegi/my_page.dart';
import 'package:samsisegi/write_diary/select_emotions.dart';
import 'package:samsisegi/write_diary/view_diary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom_component/custom_bottom_navigation_bar.dart';
import '../custom_component/empty_home_content.dart';
import '../custom_component/home_content.dart';
import '../diary_data/diary_entry.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeContents extends StatefulWidget {
  static const routeName = '/home';
  final DateTime selectedDate;

  const HomeContents({super.key, required this.selectedDate});

  @override
  State<HomeContents> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeContents> with RouteAware {
  String? nickName = '';
  DateTime currentDate = DateTime.now();
  Map<String, DiaryEntry?> entries = {};

  @override
  void initState() {
    super.initState();
    currentDate = widget.selectedDate;
    print("HomeContents에서 사용될 날짜: $currentDate");
    _loadMonthlyEntries(); // 초기화 시 해당 월의 일기 데이터 불러오기
  }

  @override
  void didUpdateWidget(covariant HomeContents oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate) {
      setState(() {
        currentDate =
            widget.selectedDate; // widget.selectedDate로 currentDate 갱신
        _loadMonthlyEntries(); // 날짜가 바뀔 때 일기 항목 다시 불러오기
      });
    }
  }

  Future<void> _loadMonthlyEntries() async {
    String yearMonth = DateFormat('yyyy-MM').format(currentDate);

    if (DiaryCache.getMonthlyEntries(yearMonth) == null) {
      await DiaryCache.loadMonthlyEntries(yearMonth);
    }

    _loadEntriesForCurrentDate();
  }

  void _loadEntriesForCurrentDate() {
    String yearMonth = DateFormat('yyyy-MM').format(currentDate);
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    // 해당 월의 데이터를 가져옴
    final monthlyEntries = DiaryCache.getMonthlyEntries(yearMonth);

    if (monthlyEntries != null) {
      // 필터링을 위해 각 시간대에 맞는 데이터를 직접 찾음
      DiaryEntry? morningEntry;
      DiaryEntry? afternoonEntry;
      DiaryEntry? nightEntry;

      for (var entry in monthlyEntries) {
        if (entry.date == formattedDate) {
          if (entry.period == 'morning') {
            morningEntry = entry;
          } else if (entry.period == 'afternoon') {
            afternoonEntry = entry;
          } else if (entry.period == 'night') {
            nightEntry = entry;
          }
        }
      }

      // 찾은 데이터를 entries에 할당
      entries = {
        'morning': morningEntry,
        'afternoon': afternoonEntry,
        'night': nightEntry,
      };
    } else {
      entries = {}; // 데이터가 없으면 빈 맵 설정
    }

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ModalRoute를 PageRoute로 변환
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute); // RouteObserver에 구독
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this); // RouteObserver 구독 해제
    super.dispose();
  }

  @override
  void didPopNext() {
    // HomeScreen으로 다시 돌아왔을 때 호출됨
    _loadEntriesForCurrentDate(); // 데이터를 다시 불러옴
    super.didPopNext();
  }

  Future<void> _loadDiaryEntries() async {
    entries = await DiaryManager.loadEntries(currentDate); // 분리된 로직 호출
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
          _checkAndLoadNewMonth();
        } else if (details.primaryVelocity! > 0) {
          setState(() =>
              currentDate = currentDate.subtract(const Duration(days: 1)));
          _checkAndLoadNewMonth();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
      ),
    );
  }

  Divider _buildDivider() => Divider(color: Colors.black, height: 1.h);

  Widget _buildHomeContent(
      String period, String contentText, String timeText, Color timeColor) {
    final entry = entries[period];

    bool isTimeDisabled = timeColor == AppColors.gray;

    if (entry != null) {
      return GestureDetector(
        onTap: isTimeDisabled
            ? null
            : () {
                String diaryKey =
                    '${DateFormat('yyyy-MM-dd').format(currentDate)}_$period';
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ViewDiary(diaryKey: diaryKey),
                  ),
                );
              },
        child: HomeContent(
            timeText: timeText,
            titleText: entry.title,
            contentText: entry.content),
      );
    } else {
      return EmptyHomeContent(
        timeText: timeText,
        contentText: contentText,
        timeColor: timeColor,
        onTap: isTimeDisabled
            ? null
            : () {
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

  void _checkAndLoadNewMonth() {
    String newMonth = DateFormat('yyyy-MM').format(currentDate);
    if (DiaryCache.getMonthlyEntries(newMonth) == null) {
      _loadMonthlyEntries(); // 새로운 월의 데이터를 불러옴
    } else {
      _loadEntriesForCurrentDate(); // 캐시된 데이터 사용
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

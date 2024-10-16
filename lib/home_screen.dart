import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:samsisegi/custom_component/custom_bottom_navigation_bar.dart';
import 'package:samsisegi/custom_component/empty_home_content.dart';
import 'package:samsisegi/custom_component/home_content.dart';
import 'package:samsisegi/design_system.dart';

import 'package:samsisegi/my_page.dart';
import 'package:samsisegi/write_diary/select_emotions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'diary_data/diary_entry.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? nickName = '';
  int _currentIndex = 0;
  DateTime currentDate = DateTime.now(); // 현재 화면에 표시된 날짜
  Map<String, DiaryEntry?> entries = {};

  void _onSwipeLeft() {
    setState(() {
      currentDate = currentDate.add(Duration(days: 1)); // 하루 전
      _loadDiaryEntries();
    });
  }

  void _onSwipeRight() {
    setState(() {
      currentDate = currentDate.subtract(Duration(days: 1)); // 하루 후
      _loadDiaryEntries();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadNickName();
    _loadDiaryEntries();
  }

  // 일기 데이터를 불러오는 함수
  Future<void> _loadDiaryEntries() async {
    final box = await Hive.openBox<DiaryEntry>('diaryBox');

    for (var period in ['morning', 'afternoon', 'night']) {
      String key = '${DateFormat('yyyy-MM-dd').format(currentDate)}_$period';
      final entry = box.get(key);

      // 디버깅용으로 로그 추가
      print('불러온 키: $key, 불러온 데이터: ${entry?.toString()}');

      setState(() {
        entries[period] = entry; // 각 시간대의 일기 데이터를 맵에 저장
      });
    }
  }

  // 닉네임 불러오기 함수
  void _loadNickName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nickName = prefs.getString('nickName') ?? '무명의 기록자';
    });
  }

  // 현재 날짜 관련 함수들
  String getCurrentDate() => DateFormat('MMM dd').format(DateTime.now());
  String getCurrentYear() => DateFormat('yyyy').format(DateTime.now());
  String getCurrentDay() => DateFormat('EEE').format(DateTime.now());

  // 시간에 따른 인사말 반환
  String getGreetingMessage() {
    int currentHour = DateTime.now().hour;
    if (currentHour >= 5 && currentHour < 12) {
      return "좋은 아침이에요,";
    } else if (currentHour >= 12 && currentHour < 18) {
      return "좋은 오후예요,";
    } else if (currentHour >= 18 && currentHour < 22) {
      return "좋은 저녁이에요,";
    } else {
      return "좋은 밤이에요";
    }
  }

  // 활성화 여부 체크 함수
  bool isActive(Color color) => color == AppColors.primary;

  // 네비게이션 탭 클릭 처리
  void _onItemTapped(int index) {
    if (index == _currentIndex) {
      _refreshCurrentPage();
    } else {
      setState(() {
        _currentIndex = index;
      });

      // 페이지 이동 처리
      switch (index) {
        case 0:
          _navigateToPage(const HomeScreen(), 0);
          break;
        case 1:
          DateTime now = DateTime.now();
          String formattedDate = DateFormat('yyyy-MM-dd').format(now);
          String period;

          // 시간대에 따른 분기 처리 (새벽 5시 이전이면 전날 밤)
          if (now.hour >= 5 && now.hour < 12) {
            formattedDate = DateFormat('yyyy-MM-dd').format(now);
            period = 'morning'; // 아침
          } else if (now.hour >= 12 && now.hour < 18) {
            formattedDate = DateFormat('yyyy-MM-dd').format(now);
            period = 'afternoon'; // 오후
          } else if (now.hour >= 18 && now.hour < 24) {
            formattedDate = DateFormat('yyyy-MM-dd').format(now);
            period = 'night'; // 저녁/밤
          } else {
            // 새벽 5시 이전이면 전날 밤
            DateTime previousDay = now.subtract(const Duration(days: 1));
            formattedDate = DateFormat('yyyy-MM-dd').format(previousDay);
            period = 'night'; // 전날 저녁/밤
          }

          _navigateToPage(
              SelectEmotions(
                date: formattedDate,
                period: period,
              ),
              1);
          break;
        case 2:
          _navigateToPage(const MyPage(), 2);
          break;
      }
    }
  }

  // 페이지 이동 후 돌아왔을 때 인덱스 복구
  Future<void> _navigateToPage(Widget page, int index) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => page),
    ).then((_) {
      setState(() {
        _currentIndex = 0;
      });
    });
  }

  // 현재 페이지 새로고침
  void _refreshCurrentPage() {
    setState(() {});
  }

  // onTap 이벤트에서 사용될 saveDiary 함수
  Future<void> saveDiary(DiaryEntry entry) async {
    final box = await Hive.openBox<DiaryEntry>('diaryBox');
    await box.put('${entry.date}_${entry.period}', entry); // 데이터 저장
    await box.close();
  }

  // 시간대에 맞는 색상 반환
  Color getTimeColor(int startHour, int endHour) {
    DateTime now = DateTime.now();
    DateTime selectedDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);

    // 선택한 날짜가 오늘 이전일 경우 모든 영역 primary 색상
    if (selectedDate.isBefore(DateTime(now.year, now.month, now.day))) {
      return AppColors.primary;
    }
    // 선택한 날짜가 오늘 이후일 경우 모든 영역 비활성화 (gray)
    else if (selectedDate.isAfter(DateTime(now.year, now.month, now.day))) {
      return AppColors.gray;
    }
    // 오늘일 경우 시간대에 따라 색상 결정
    else {
      int currentHour = now.hour;
      return currentHour >= startHour && currentHour < endHour
          ? AppColors.primary
          : AppColors.gray;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color morning = getTimeColor(5, 24);
    Color afternoon = getTimeColor(12, 24);
    Color night = getTimeColor(18, 24);

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          _onSwipeLeft();
        } else if (details.primaryVelocity! > 0) {
          _onSwipeRight();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(44.h),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            titleSpacing: 0,
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Text(
                    getGreetingMessage(),
                    style: AppTextStyles.appBarExtraLight,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '$nickName님',
                    style: AppTextStyles.appBarSemiBold,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                height: 1.h,
                color: Colors.black,
              ),
              SizedBox(height: 40.h),
              _buildDateSection(),
              SizedBox(height: 40.h),
              _buildHomeContent("朝 |", "오늘 아침은 어땠나요?", morning, "morning"),
              SizedBox(height: 16.h),
              _buildHomeContent("午 |", "오늘 오후는 어땠나요?", afternoon, "afternoon"),
              SizedBox(height: 16.h),
              _buildHomeContent("夜 |", "오늘 저녁/밤은 어땠나요?", night, "night"),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewPadding.bottom),
          child: CustomBottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  // 날짜 섹션 위젯 생성 함수
  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('MMM dd').format(currentDate), // 화면에 표시되는 날짜
          style: TextStyle(
            color: AppColors.primary,
            fontFamily: 'SuitSemiBold',
            fontSize: 64.sp,
            height: 1,
            wordSpacing: 64 * -0.02,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 85.w),
              child: Text(
                DateFormat('yyyy').format(currentDate), // 연도 표시
                style: TextStyle(
                  color: AppColors.primary,
                  fontFamily: 'SuitSemiBold',
                  fontSize: 64.sp,
                  height: 1,
                  wordSpacing: 64 * -0.02,
                ),
              ),
            ),
            Spacer(),
            Text(
              '/${DateFormat('EEE').format(currentDate)}', // 요일 표시
              style: TextStyle(
                color: AppColors.gray,
                fontFamily: 'SuitRegular',
                fontSize: 32.sp,
                height: 45 / 32,
                wordSpacing: -0.64,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // HomeContent 위젯 생성 함수
  Widget _buildHomeContent(
      String timeText, String contentText, Color timeColor, String period) {
    final diaryEntry = entries[period]; // 현재 시간대에 해당하는 일기 데이터 확인

    if (diaryEntry != null) {
      // 일기 데이터가 있는 경우 HomeContent 위젯을 사용해 보여줌
      return HomeContent(
        timeText: timeText,
        titleText: diaryEntry.title, // 저장된 일기의 제목
        contentText: diaryEntry.content, // 저장된 일기의 내용
      );
    } else {
      // 일기 데이터가 없는 경우 EmptyHomeContent를 보여줌
      return EmptyHomeContent(
        timeText: timeText,
        contentText: contentText, // 기본 문구
        timeColor: timeColor,
        onTap: () async {
          // 현재 날짜 가져오기
          String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

          // 감정 선택 화면으로 이동 (일기 작성 전)
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => SelectEmotions(
                date: formattedDate,
                period: period,
              ),
            ),
          );
        },
      );
    }
  }
}

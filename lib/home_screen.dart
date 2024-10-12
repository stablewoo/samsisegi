import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:samsisegi/custom_component/custom_bottom_navigation_bar.dart';
import 'package:samsisegi/custom_component/empty_home_content.dart';
import 'package:samsisegi/design_system.dart';
import 'package:samsisegi/my_page.dart';
import 'package:samsisegi/write_diary/select_emotions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? nickName = '';
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadNickName();
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

  // 시간대에 맞는 색상 반환
  Color getTimeColor(int startHour, int endHour) {
    int currentHour = DateTime.now().hour;
    return currentHour >= startHour && currentHour < endHour
        ? AppColors.primary
        : AppColors.gray;
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
          _navigateToPage(const SelectEmotions(), 1);
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

  @override
  Widget build(BuildContext context) {
    Color morning = getTimeColor(5, 24);
    Color afternoon = getTimeColor(12, 24);
    Color night = getTimeColor(18, 24);

    return Scaffold(
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
            _buildEmptyHomeContent("朝 |", "오늘 아침은 어땠나요?", morning),
            SizedBox(height: 16.h),
            _buildEmptyHomeContent("午 |", "오늘 오후는 어땠나요?", afternoon),
            SizedBox(height: 16.h),
            _buildEmptyHomeContent("夜 |", "오늘 저녁/밤은 어땠나요?", night),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
        child: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
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
          getCurrentDate(),
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
                getCurrentYear(),
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
              '/${getCurrentDay()}',
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

  // EmptyHomeContent 위젯 생성 함수
  Widget _buildEmptyHomeContent(
      String timeText, String contentText, Color timeColor) {
    return EmptyHomeContent(
      timeText: timeText,
      contentText: contentText,
      timeColor: timeColor,
      onTap: isActive(timeColor)
          ? () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => SelectEmotions()),
              );
            }
          : null,
    );
  }
}

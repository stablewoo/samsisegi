import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:samsisegi/custom_component/custom_bottom_navigation_bar.dart';
import 'package:samsisegi/design_system.dart';
import 'package:samsisegi/home_screen/home_contents.dart';
import 'package:samsisegi/my_page.dart';
import 'package:samsisegi/write_diary/select_emotions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  DateTime currentDate = DateTime.now();
  String? nickName = '';

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

  // MyPage에서 선택된 날짜를 처리하는 함수
  void _onDateSelected(DateTime selectedDate) {
    setState(() {
      currentDate = selectedDate; // 선택된 날짜로 홈 화면 갱신
      _currentIndex = 0; // 홈 화면으로 전환
    });
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex && index == 0) {
      // 이미 홈 화면에 있을 때만 '오늘' 날짜로 갱신
      setState(() {
        currentDate = DateTime.now(); // '오늘' 날짜로 갱신
      });
      _refreshCurrentPage();
    } else {
      setState(() {
        _currentIndex = index;
      });

      // 페이지 이동 처리
      switch (index) {
        case 0:
          // 홈 화면으로 전환 시
          _currentIndex = 0;
          break;
        case 1:
          // SelectEmotions 화면으로 이동
          _navigateToSelectEmotionsPage();
          break;
        case 2:
          // MyPage로 전환 시
          _currentIndex = 2;
          break;
      }
    }
  }

  Future<void> _navigateToSelectEmotionsPage() async {
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

    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) =>
            SelectEmotions(date: formattedDate, period: period),
      ),
    );

    // 돌아왔을 때 홈 화면 갱신
    if (result != null && result is DateTime) {
      setState(() {
        currentDate = result; // 전달된 날짜로 홈 화면 갱신
        _currentIndex = 0; // 홈 화면으로 인덱스 전환
      });
    } else {
      setState(() {
        _currentIndex = 0; // 홈 화면으로 인덱스 전환
      });
    }
  }

  void _refreshCurrentPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44.h),
        child: _buildAppBar(),
      ),
      body: IndexedStack(
        index: _currentIndex, // 현재 선택된 탭의 인덱스
        children: [
          HomeContents(
            selectedDate: currentDate,
          ), // 0번 탭: 홈 화면
          Container(), // 1번 탭은 화면 이동만, 여기서는 빈 컨테이너
          MyPage(onDateSelected: _onDateSelected), // 2번 탭: 마이 페이지
        ],
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

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            Text("안녕하세요,", style: AppTextStyles.appBarExtraLight),
            SizedBox(width: 2.w),
            Text('$nickName님', style: AppTextStyles.appBarSemiBold),
          ],
        ),
      ),
    );
  }
}

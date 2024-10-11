import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:samsisegi/custom_component/custom_bottom_navigation_bar.dart';
import 'package:samsisegi/custom_component/home_content.dart';
import 'package:samsisegi/design_system.dart';
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

  void _loadNickName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nickName = prefs.getString('nickName') ?? '무명의 기록자';
    });
  }

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
      if (index == 1) {
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(
            builder: (context) => const SelectEmotions(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  '좋은 아침이에요,',
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
            Text(
              'Oct 07',
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
                    '2024',
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
                  '/Mon',
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
            SizedBox(height: 40.h),
            const HomeContent(
                timeText: '朝 |',
                titleText: '일이삼사오육칠팔구십십이',
                contentText:
                    '일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자'),
            SizedBox(height: 16.h),
            const HomeContent(
                timeText: '午 |',
                titleText: '일이삼사오육칠팔구십십이',
                contentText:
                    '일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자'),
            SizedBox(height: 16.h),
            const HomeContent(
                timeText: '夜 |',
                titleText: '일이삼사오육칠팔구십십이',
                contentText:
                    '일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자일기를쓰자'),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex, onTap: _onItemTapped),
    );
  }
}

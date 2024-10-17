import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:samsisegi/custom_component/custom_button.dart';
import 'package:samsisegi/design_system.dart';
import 'package:samsisegi/home_screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NickNameSetting extends StatefulWidget {
  static const String routeName = '/nick_name_setting';
  const NickNameSetting({super.key});

  @override
  State<NickNameSetting> createState() => _NickNameSettingState();
}

class _NickNameSettingState extends State<NickNameSetting> {
  String nickName = ''; // 닉네임 입력값
  bool isEnable = false; // 버튼 활성화 여부

  final FocusNode _focusNode = FocusNode(); // 텍스트 필드 포커스 제어

  // 닉네임 입력값에 따른 상태 업데이트
  void _onNickNameChanged(String value) {
    setState(() {
      nickName = value;
      isEnable = nickName.isNotEmpty;
    });
  }

  // 닉네임 저장 (SharedPreferences 사용)
  Future<void> _saveNickName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nickName', nickName);
    debugPrint("닉네임 저장 완료: $nickName");
  }

  @override
  void initState() {
    super.initState();
    // 화면이 그려진 후 텍스트 필드에 포커스 설정
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose(); // 포커스 노드 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 키보드가 열려 있는지 여부 확인
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 40;

    // 키보드 상태에 따라 하단 패딩 조정
    double bottomPadding = isKeyboardVisible
        ? MediaQuery.of(context).viewInsets.bottom + 16.h // 키보드 위로 16px
        : 16.h + MediaQuery.of(context).viewPadding.bottom; // 안전 영역 기준 16px

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            children: [
              Text('삼시세기', style: AppTextStyles.appBarSemiBold),
              Text('에 오신 것을 환영해요', style: AppTextStyles.appBarExtraLight),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Divider(thickness: 1.h, color: Colors.black),
            SizedBox(height: 40.h),
            Text(
              '삼시세기에서\n사용하고자 하는\n닉네임을 설정해주세요!',
              style: AppTextStyles.header24,
            ),
            SizedBox(height: 10.h),
            Text('8자 이하', style: AppTextStyles.subtitle14),
            SizedBox(height: 50.h),
            TextField(
              focusNode: _focusNode,
              cursorHeight: 36.h,
              cursorRadius: const Radius.circular(1),
              inputFormatters: [
                LengthLimitingTextInputFormatter(8), // 8자 제한
              ],
              onChanged: _onNickNameChanged,
              decoration: InputDecoration(
                hintText: '닉네임 입력',
                hintStyle: TextStyle(
                  fontFamily: 'SuitSemiBold',
                  color: AppColors.gray,
                  fontSize: 30.sp,
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 30.sp),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          bottom: bottomPadding,
        ),
        child: PrimaryButtonH48(
            text: '다음',
            isEnable: isEnable, // 버튼 활성화 여부
            onPressed: () {
              _saveNickName(); // 닉네임 저장
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) => const HomeScreen(),
                  settings: const RouteSettings(name: HomeScreen.routeName),
                ),
              );
            }
            // 활성화되지 않으면 null 처리
            ),
      ),
    );
  }
}

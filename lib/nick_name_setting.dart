import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:samsisegi/custom_component/custom_button.dart';

class NickNameSetting extends StatefulWidget {
  const NickNameSetting({super.key});

  @override
  State<NickNameSetting> createState() => _NickNameSettingState();
}

class _NickNameSettingState extends State<NickNameSetting> {
  String nickName = '';
  bool isEnable = false;

  void _onNickNameChanged(String value) {
    setState(() {
      nickName = value;
      isEnable = nickName.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44.h),
        child: AppBar(
          backgroundColor: Colors.white,
          title: const Text('삼시세기에 오신 것을 환영해요'),
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
            Text('삼시세기에서\n사용하고자 하는\n닉네임을 설정해주세요!'),
            SizedBox(height: 10.h),
            Text('8자 이하'),
            SizedBox(height: 50.h),
            TextField(
              cursorHeight: 36.h,
              cursorRadius: const Radius.circular(1),
              inputFormatters: [
                LengthLimitingTextInputFormatter(8),
              ],
              onChanged: _onNickNameChanged,
              decoration: InputDecoration(
                hintText: '닉네임 입력',
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 30.sp,
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(
                fontSize: 30.sp,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
            left: 20.w,
            right: 20.w,
            bottom: MediaQuery.of(context).viewInsets.bottom > 0
                ? MediaQuery.of(context).viewInsets.bottom + 16.h
                : 16.h + MediaQuery.of(context).viewPadding.bottom,
            top: 16.h),
        child:
            PrimaryButtonH48(text: '다음', isEnable: isEnable, onPressed: () {}),
      ),
    );
  }
}

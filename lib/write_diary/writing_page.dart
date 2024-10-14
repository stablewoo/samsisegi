import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:samsisegi/custom_component/custom_button.dart';
import 'package:samsisegi/design_system.dart';

class WritingPage extends StatefulWidget {
  const WritingPage({super.key});

  @override
  State<WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  final FocusNode _titleFocusNode = FocusNode(); // 텍스트 필드 포커스 제어
  final FocusNode _diaryFocusNode = FocusNode();
  final TextEditingController _textController =
      TextEditingController(); //텍스트 필드 컨트롤러
  final TextEditingController _diaryController = TextEditingController();
  bool isNextButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _diaryFocusNode.addListener(() {
      if (!_diaryFocusNode.hasFocus) {
        final trimmedText = _diaryController.text.trim();
        if (trimmedText.isEmpty) {
          _diaryController.clear();
        }
      }
    });

    _textController.addListener(_checkFormValidity);
    _diaryController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _titleFocusNode.dispose(); // 포커스 노드 해제
    _diaryFocusNode.dispose();
    _textController.dispose(); // 컨트롤러 해제
    _diaryController.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    _titleFocusNode.unfocus();
    _diaryFocusNode.unfocus();
  }

  void _checkFormValidity() {
    setState(() {
      isNextButtonEnabled = _textController.text.trim().isNotEmpty &&
          _diaryController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _dismissKeyboard,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(44.h),
          child: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset('assets/icons/back_arrow_24.svg'),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  height: 1.h,
                  color: Colors.black,
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '24 / 10 / 06, 아침',
                      style: TextStyle(
                        color: Color(0xFF8D8C82),
                        fontFamily: 'SuitRegular',
                        fontSize: 16.sp,
                        height: 24 / 16,
                        wordSpacing: -0.32,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '편안해요',
                      style: TextStyle(
                        color: Color(0xFF8D8C82),
                        fontFamily: 'SuitRegular',
                        fontSize: 16.sp,
                        height: 24 / 16,
                        wordSpacing: -0.32,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 48.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        focusNode: _titleFocusNode,
                        cursorHeight: 36.h,
                        cursorRadius: const Radius.circular(1),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(12), // 12자 제한
                        ],
                        decoration: InputDecoration(
                          hintText: '제목 입력',
                          hintStyle: TextStyle(
                            fontFamily: 'SuitSemiBold',
                            color: AppColors.gray,
                            fontSize: 30.sp,
                            wordSpacing: -0.60,
                            height: 36 / 30,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontFamily: 'SuitSemiBold',
                          color: AppColors.primary,
                          fontSize: 30.sp,
                          wordSpacing: -0.60,
                          height: 36 / 30,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${_textController.text.length}/12',
                      style: TextStyle(
                        fontFamily: 'SuitMedium',
                        fontSize: 10.sp,
                        height: 17 / 10,
                        wordSpacing: -0.20,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 36.h),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 335.w,
                  ),
                  child: TextField(
                    controller: _diaryController,
                    focusNode: _diaryFocusNode,
                    maxLines: null,
                    minLines: 1,
                    keyboardType: TextInputType.multiline,
                    cursorHeight: 17.h,
                    cursorRadius: const Radius.circular(1),
                    decoration: InputDecoration(
                      hintText: '일기 입력',
                      hintStyle: TextStyle(
                        fontFamily: 'SuitMedium',
                        color: AppColors.gray,
                        fontSize: 14.sp,
                        wordSpacing: -0.28,
                        height: 20 / 14,
                      ),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: const Color(0xFF6F6F6F),
                      fontFamily: 'SuitMedium',
                      fontSize: 14.sp,
                      wordSpacing: -0.28,
                      height: 20 / 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
              left: 20.w,
              right: 20.w,
              bottom: 16.h + MediaQuery.of(context).viewPadding.bottom,
              top: 16.h),
          child: PrimaryButtonH48(
            text: '일기 저장',
            isEnable: isNextButtonEnabled, // 태그 선택 상태에 따라 버튼 활성화
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}

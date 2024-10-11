import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:samsisegi/custom_component/custom_button.dart';
import 'package:samsisegi/custom_component/emotion_select_box.dart';
import 'package:samsisegi/custom_component/emotion_tag.dart';
import 'package:samsisegi/design_system.dart';

class SelectEmotions extends StatefulWidget {
  const SelectEmotions({super.key});

  @override
  State<SelectEmotions> createState() => _SelectEmotionsState();
}

class _SelectEmotionsState extends State<SelectEmotions> {
  String? selectedEmotion;
  int _selectedIndex = -1;

  void onEmotionSelected(String emotion, int index) {
    setState(() {
      if (_selectedIndex == index) {
        selectedEmotion = null;
        _selectedIndex = -1;
      } else {
        selectedEmotion = emotion;
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: SvgPicture.asset('assets/icons/back_arrow_24.svg'),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              Text(
                '오늘 아침을 표현해요',
                style: TextStyle(
                  color: AppColors.primary,
                  fontFamily: 'SuitBold',
                  fontSize: 28.sp,
                  height: 32 / 28,
                  wordSpacing: -0.56,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '아침의 전반적인 느낌은 어땠나요?',
                style: TextStyle(
                  color: AppColors.primary,
                  fontFamily: 'SuitRegular',
                  fontSize: 16.sp,
                  height: 24 / 16,
                  wordSpacing: -0.32,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  EmotionSelectBox(
                    emotionText: '편안해요',
                    imagePath: 'assets/images/comfortable_32.png',
                    isSelected: _selectedIndex == 0,
                    onTap: () => onEmotionSelected('편안해요', 0),
                  ),
                  const Spacer(),
                  EmotionSelectBox(
                      emotionText: '기분 최고',
                      imagePath: 'assets/images/feel_great_32.png',
                      isSelected: _selectedIndex == 1,
                      onTap: () => onEmotionSelected('기분 최고', 1)),
                  const Spacer(),
                  EmotionSelectBox(
                      emotionText: '신나요',
                      imagePath: 'assets/images/excited_32.png',
                      isSelected: _selectedIndex == 2,
                      onTap: () => onEmotionSelected('신나요', 2)),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  EmotionSelectBox(
                      emotionText: '귀찮아요',
                      imagePath: 'assets/images/lazy_32.png',
                      isSelected: _selectedIndex == 3,
                      onTap: () => onEmotionSelected('귀찮아요', 3)),
                  Spacer(),
                  EmotionSelectBox(
                      emotionText: '그저 그래요',
                      imagePath: 'assets/images/soso_32.png',
                      isSelected: _selectedIndex == 4,
                      onTap: () => onEmotionSelected('그저 그래요', 4)),
                  Spacer(),
                  EmotionSelectBox(
                      emotionText: '피곤해요',
                      imagePath: 'assets/images/tired_32.png',
                      isSelected: _selectedIndex == 5,
                      onTap: () => onEmotionSelected('피곤해요', 5)),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  EmotionSelectBox(
                      emotionText: '우울해요',
                      imagePath: 'assets/images/depressed_32.png',
                      isSelected: _selectedIndex == 6,
                      onTap: () => onEmotionSelected('우울해요', 6)),
                  Spacer(),
                  EmotionSelectBox(
                      emotionText: '짜증나요',
                      imagePath: 'assets/images/frustrated_32.png',
                      isSelected: _selectedIndex == 7,
                      onTap: () => onEmotionSelected('짜증나요', 7)),
                  Spacer(),
                  EmotionSelectBox(
                      emotionText: '극대노',
                      imagePath: 'assets/images/furious_32.png',
                      isSelected: _selectedIndex == 8,
                      onTap: () => onEmotionSelected('극대노', 8)),
                ],
              ),
              SizedBox(height: 40.h),
              Text(
                '이 기분을 가장 잘 나타내는 표현은\n무엇인가요?',
                style: TextStyle(
                  color: AppColors.primary,
                  fontFamily: 'SuitRegular',
                  fontSize: 16.sp,
                  height: 24 / 16,
                  wordSpacing: -0.32,
                ),
              ),
              SizedBox(height: 20.h),
              if (selectedEmotion != null) _buildEmotionTags(selectedEmotion!),
              SizedBox(height: 24.h),
            ],
          ),
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
        child: PrimaryButtonH48(
          text: '다음',
          isEnable: true,
          onPressed: () {},
        ),
      ),
    );
  }
}

Widget _buildEmotionTags(String emotion) {
  switch (emotion) {
    case '편안해요':
    case '기분 최고':
    case '신나요':
      return const HappyEmotionTag(); // 행복한 감정에 맞는 태그 컴포넌트
    case '그저 그래요':
    case '귀찮아요':
    case '피곤해요':
      return const SosoEmotionTags(); // 무난한 감정에 맞는 태그 컴포넌트
    case '우울해요':
    case '짜증나요':
    case '극대노':
      return const BadEmotionTags(); // 부정적인 감정에 맞는 태그 컴포넌트
    default:
      return Container(); // 기본 빈 컨테이너
  }
}

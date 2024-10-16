import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:samsisegi/custom_component/custom_button.dart';
import 'package:samsisegi/custom_component/emotion_select_box.dart';
import 'package:samsisegi/custom_component/emotion_tag.dart';
import 'package:samsisegi/design_system.dart';
import 'package:samsisegi/write_diary/writing_page.dart';

class SelectEmotions extends StatefulWidget {
  final String date;
  final String period;
  const SelectEmotions({super.key, required this.date, required this.period});

  @override
  State<SelectEmotions> createState() => _SelectEmotionsState();
}

class _SelectEmotionsState extends State<SelectEmotions> {
  String? selectedEmotion;
  int _selectedIndex = -1;
  List<String> selectedTags = [];

  bool isToday() {
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return widget.date == todayDate;
  }

  String getEmotionPrompt() {
    if (isToday()) {
      switch (widget.period) {
        case 'morning':
          return '오늘 아침을 표현해요';
        case 'afternoon':
          return '오늘 오후를 표현해요';
        case 'evening':
          return '오늘 저녁/밤을 표현해요';
        default:
          return '오늘 하루를 표현해요';
      }
    } else {
      DateTime selectedDate = DateFormat("yyyy-MM-dd").parse(widget.date);
      String newFormatDate = DateFormat('MM/dd').format(selectedDate);

      // 시간대도 한글로 변환
      String koreanPeriod;
      switch (widget.period) {
        case 'morning':
          koreanPeriod = '아침';
          break;
        case 'afternoon':
          koreanPeriod = '오후';
          break;
        case 'night':
          koreanPeriod = '저녁/밤';
          break;
        default:
          koreanPeriod = '시간대';
      }

      return '$newFormatDate의 $koreanPeriod을 표현해요';
    }
  }

  String getSubtitlePrompt() {
    switch (widget.period) {
      case 'morning':
        return '아침의 전반적인 느낌은 어땟나요?';
      case 'afternoon':
        return '오후의 전반적인 느낌은 어땟나요?';
      case 'night':
        return '저녁/밤의 전반적인 느낌은 어땟나요?';
      default:
        return '하루의 전반적인 느낌은 어땟나요?';
    }
  }

//감정 선택 시 호출되는 함수
  void onEmotionSelected(String emotion, int index) {
    setState(() {
      if (_selectedIndex == index) {
        selectedEmotion = null;
        _selectedIndex = -1;
      } else {
        selectedEmotion = emotion;
        _selectedIndex = index;
      }
      selectedTags.clear();
    });
  }

//태그 선택/해제 시 호출되는 함수
  void onTagTapped(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
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
                getEmotionPrompt(),
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
                getSubtitlePrompt(),
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
          isEnable: selectedTags.isNotEmpty, // 태그 선택 상태에 따라 버튼 활성화
          onPressed: selectedTags.isNotEmpty
              ? () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => WritingPage(
                          date: widget.date, // 이전에 전달받은 날짜
                          period: widget.period,
                          emotion: selectedEmotion ?? '감정 없음',
                          tags: selectedTags),
                    ),
                  );
                }
              : () {},
        ),
      ),
    );
  }

  Widget _buildEmotionTags(String emotion) {
    switch (emotion) {
      case '편안해요':
      case '기분 최고':
      case '신나요':
        return HappyEmotionTag(
            onTagTapped: onTagTapped,
            selectedTags: selectedTags); // 행복한 감정에 맞는 태그 컴포넌트
      case '그저 그래요':
      case '귀찮아요':
      case '피곤해요':
        return SosoEmotionTags(
            onTagTapped: onTagTapped,
            selectedTags: selectedTags); // 무난한 감정에 맞는 태그 컴포넌트
      case '우울해요':
      case '짜증나요':
      case '극대노':
        return BadEmotionTags(
            onTagTapped: onTagTapped,
            selectedTags: selectedTags); // 부정적인 감정에 맞는 태그 컴포넌트
      default:
        return Container(); // 기본 빈 컨테이너
    }
  }
}

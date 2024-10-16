import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:samsisegi/custom_component/custom_button.dart';
import 'package:samsisegi/design_system.dart';
import 'package:samsisegi/diary_data/diary_entry.dart';
import 'package:samsisegi/write_diary/view_diary.dart';

class WritingPage extends StatefulWidget {
  final String date;
  final String period;
  final String emotion;
  final List<String> tags;
  const WritingPage({
    super.key,
    required this.emotion,
    required this.tags,
    required this.date,
    required this.period,
  });

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
    final isTitleValid = _textController.text.trim().isNotEmpty;
    final isContentValid = _diaryController.text.trim().isNotEmpty;

    if (isNextButtonEnabled != (isTitleValid && isContentValid)) {
      setState(() {
        isNextButtonEnabled = isTitleValid && isContentValid;
      });
    }
  }

  String getFormattedDate() {
    // 날짜 형식을 "yyyy년 MM월 dd일"로 변환
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(widget.date);
    return DateFormat('yyyy/MM/dd').format(parsedDate);
  }

  String getFormattedPeriod() {
    print('widget.period 값: ${widget.period}');
    // 시간대에 따른 한글 변환
    switch (widget.period) {
      case 'morning':
        return '아침';
      case 'afternoon':
        return '오후';
      case 'evening':
        return '저녁/밤';
      default:
        return '시간대';
    }
  }

  Future<void> saveDiaryEntry() async {
    final box = await Hive.openBox<DiaryEntry>('diaryBox');

    final newDiary = DiaryEntry(
      date: widget.date,
      period: widget.period,
      emotion: widget.emotion,
      tags: widget.tags,
      title: _textController.text,
      content: _diaryController.text,
    );

    // Key는 날짜와 시간대를 조합한 값으로 설정
    String key = '${widget.date}_${widget.period}';

    // Key를 사용하여 일기를 저장
    await box.put(key, newDiary); // 일기 저장 (key를 사용)

    print('일기 저장 완료: ${newDiary.toString()}'); // 저장된 일기 데이터 출력
    print('저장된 키: $key'); // 저장된 Key 출력
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
                      '${getFormattedDate()}, ${getFormattedPeriod()}',
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
                      '${widget.emotion}',
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
            onPressed: () async {
              String key = '${widget.date}_${widget.period}';

              await saveDiaryEntry();

              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ViewDiary(
                    diaryKey: key,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

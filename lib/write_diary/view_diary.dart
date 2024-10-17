import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:samsisegi/design_system.dart';
import 'package:samsisegi/diary_data/diary_entry.dart';
import 'package:samsisegi/home_screen/home_screen.dart';

class ViewDiary extends StatefulWidget {
  final String diaryKey;

  const ViewDiary({
    super.key,
    required this.diaryKey,
  });

  @override
  State<ViewDiary> createState() => _ViewDiaryState();
}

class _ViewDiaryState extends State<ViewDiary> {
  DiaryEntry? diaryEntry;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDiaryEntry();
  }

  Future<void> _loadDiaryEntry() async {
    final box = await Hive.openBox<DiaryEntry>('diaryBox'); // Hive Box 열기
    final entry = box.get(widget.diaryKey); // 기존 diaryIndex 사용

    if (entry != null) {
      print('불러온 일기 데이터: ${entry.toString()}'); // 불러온 일기 데이터 출력
    } else {
      print('일기 데이터를 불러오지 못했습니다.');
    }
    setState(() {
      diaryEntry = entry; // 가져온 일기 데이터를 diaryEntry에 저장
      isLoading = false;
    });
  }

  void _debugNavigationStack(BuildContext context) {
    Navigator.popUntil(context, (route) {
      print('Route name: ${route.settings.name}');
      return true; // 스택을 끝까지 순회할 수 있도록 true 반환
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44.h),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              // 스택 상태 확인
              _debugNavigationStack(context);

              Navigator.popUntil(
                context,
                (route) {
                  print('Checking route: ${route.settings.name}'); // 스택 탐색 시 출력
                  return route.settings.name == HomeScreen.routeName;
                },
              );
            },
            icon: SvgPicture.asset('assets/icons/back_arrow_24.svg'),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${diaryEntry != null ? getFormattedDate(diaryEntry!.date) : ''}, ${diaryEntry != null ? getFormattedPeriod(diaryEntry!.period) : ''}',
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
                  '${diaryEntry?.emotion ?? ''}',
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
            Text(
              diaryEntry?.title ?? '',
              style: TextStyle(
                fontFamily: 'SuitSemiBold',
                color: AppColors.primary,
                fontSize: 30.sp,
                wordSpacing: -0.60,
                height: 36 / 30,
              ),
            ),
            SizedBox(height: 36.h),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 335.w,
              ),
              child: Text(
                diaryEntry?.content ?? '',
                style: TextStyle(
                  color: const Color(0xFF6F6F6F),
                  fontFamily: 'SuitMedium',
                  fontSize: 14.sp,
                  wordSpacing: -0.28,
                  height: 20 / 14,
                ),
              ),
            ),
            SizedBox(height: 32.h),
            Wrap(
                spacing: 8.w,
                runSpacing: 12.h,
                children: diaryEntry?.tags?.map((tag) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.disable), // 비활성화 상태의 색상 사용
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: AppColors.gray, // 비활성화 상태의 텍스트 색상
                            fontFamily: 'SuitMedium',
                            fontSize: 15.sp,
                            height: 20 / 15,
                            wordSpacing: -0.30,
                          ),
                        ),
                      );
                    }).toList() ??
                    [])
          ],
        ),
      ),
    );
  }

  // 날짜 형식을 변환하는 함수
  String getFormattedDate(String date) {
    // "yyyy-MM-dd" 형식의 문자열을 DateTime 객체로 변환
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(date);
    // 원하는 형식으로 변환 (예: "2024년 10월 15일")
    return DateFormat('yyyy/MM/dd').format(parsedDate);
  }

  // 시간대를 한글로 변환하는 함수
  String getFormattedPeriod(String period) {
    switch (period) {
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
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:samsisegi/custom_component/custom_bottom_navigation_bar.dart';
import 'package:samsisegi/design_system.dart';
import 'package:samsisegi/diary_data/diary_cache.dart';
import 'package:samsisegi/diary_data/diary_entry.dart';
import 'package:samsisegi/main.dart';

class MyPage extends StatefulWidget {
  static const routeName = '/myPage';
  final Function(DateTime) onDateSelected;
  const MyPage({super.key, required this.onDateSelected});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with RouteAware {
  DateTime _selectedDate = DateTime.now();
  Map<String, List<DateTime>> _cachedDiaryDates = {}; // 캐시된 일기 날짜
  Map<DateTime, String> _diaryEmotions = {};
  int _currentStreak = 0;

  // 날짜 선택을 위한 메서드
  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date; // 선택된 날짜를 상태로 저장
    });
    widget.onDateSelected(date); // 선택된 날짜를 콜백으로 전달
  }

  @override
  void initState() {
    super.initState();
    _loadDiaryDates(); // Hive에서 일기 날짜 로드
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // RouteObserver를 구독
    final ModalRoute? modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
    _updateStreak();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this); // RouteObserver 구독 해제
    super.dispose();
  }

  @override
  void didPopNext() {
    // MyPage로 다시 돌아왔을 때 호출됨
    _loadDiaryDates(); // 데이터를 다시 불러옴
    _updateStreak();
    super.didPopNext();
  }

  Future<void> _loadDiaryDates() async {
    String yearMonth = DateFormat('yyyy-MM').format(_selectedDate);

    // 캐시에 해당 월의 데이터가 없으면 새로 로드
    if (!_cachedDiaryDates.containsKey(yearMonth)) {
      List<DiaryEntry>? monthlyEntries =
          DiaryCache.getMonthlyEntries(yearMonth);

      if (monthlyEntries == null) {
        await DiaryCache.loadMonthlyEntries(yearMonth);
        monthlyEntries = DiaryCache.getMonthlyEntries(yearMonth);
      }

      List<DateTime> diaryDates = [];
      Map<DateTime, String> emotions = {};

      // 월간 데이터를 처리하여 일기 날짜와 감정을 추출
      for (var entry in monthlyEntries!) {
        DateTime diaryDate = DateFormat('yyyy-MM-dd').parse(entry.date);

        if (!diaryDates.contains(diaryDate)) {
          diaryDates.add(diaryDate);
        }

        // 마지막 감정이 'night'이면 그것을 사용
        if (emotions[diaryDate] == null || entry.period == 'night') {
          emotions[diaryDate] = entry.emotion;
        }
      }

      // 캐시에 저장
      setState(() {
        _cachedDiaryDates[yearMonth] = diaryDates; // 월별로 일기 날짜 캐싱
        _diaryEmotions.addAll(emotions); // 일기 감정 캐싱
      });

      _updateStreak(); // 캐시 로드 후 streak 업데이트
    }
  }

  Future<int> _calculateStreak() async {
    DateTime today = DateTime.now();
    DateTime checkDate = today;

    // 캐시에서 오늘 일기 작성 여부 확인
    bool wroteToday = _cachedDiaryDates.values.expand((dates) => dates).any(
          (date) =>
              date.year == today.year &&
              date.month == today.month &&
              date.day == today.day,
        );

    if (!wroteToday) {
      checkDate = today.subtract(const Duration(days: 1));
    }

    print("기준이 되는 날짜: $checkDate");

    int streak = 0;

    for (int i = 0; i < 365; i++) {
      DateTime currentDate = checkDate.subtract(Duration(days: i));

      bool hasDiary = _cachedDiaryDates.values.expand((dates) => dates).any(
            (date) =>
                date.year == currentDate.year &&
                date.month == currentDate.month &&
                date.day == currentDate.day,
          );

      print("확인 중인 날짜: $checkDate, 일기 작성 여부: $hasDiary");

      if (hasDiary) {
        streak++;
      } else {
        break;
      }
    }
    print("최종 streak: $streak");
    return streak;
  }

  void _updateStreak() async {
    int streak = await _calculateStreak();
    setState(() {
      _currentStreak = streak;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16.h),
              _buildDivider(),
              SizedBox(height: 24.h),
              _streakCountdown(),
              _buildMonthSelector(),
              _buildCalendar(),
            ],
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() => Divider(color: Colors.black, height: 1.h);

  Widget _streakCountdown() {
    return Container(
      padding: EdgeInsets.only(left: 20.w, top: 17.h, bottom: 17.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6DB),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/streak_40.svg',
            width: 40.w,
            height: 40.h,
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$_currentStreak',
                    style:
                        TextStyle(fontFamily: 'SuitExtraBold', fontSize: 24.sp),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '일 연속',
                    style: TextStyle(fontFamily: 'SuitMedium', fontSize: 16.sp),
                  ),
                ],
              ),
              Text(
                '매일 오늘의 순간을 기록해보세요!',
                style: TextStyle(
                  color: AppColors.gray,
                  fontFamily: 'SuitMedium',
                  fontSize: 14.sp,
                  height: 22 / 14,
                  letterSpacing: -0.28,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              setState(() {
                _selectedDate =
                    DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
                _loadDiaryDates();
              });
            },
          ),
          SizedBox(width: 16.w),
          Text(
            DateFormat('MMM yyyy').format(_selectedDate),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 16.w),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              setState(() {
                _selectedDate =
                    DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
                _loadDiaryDates();
              });
            },
          ),
        ],
      ),
    );
  }

// 감정에 맞는 이미지 경로를 저장하는 맵 추가
  Map<String, String> emotionImageMap = {
    '편안해요': 'assets/images/comfortable_32.png',
    '기분 최고': 'assets/images/feel_great_32.png',
    '신나요': 'assets/images/excited_32.png',
    '귀찮아요': 'assets/images/lazy_32.png',
    '그저 그래요': 'assets/images/soso_32.png',
    '피곤해요': 'assets/images/tired_32.png',
    '우울해요': 'assets/images/depressed_32.png',
    '짜증나요': 'assets/images/frustrated_32.png',
    '극대노': 'assets/images/furious_32.png',
  };
  // 달력 위젯
  Widget _buildCalendar() {
    final firstDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month, 1);
    final lastDayOfMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0);
    final firstWeekDay = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    List<Widget> dayWidgets = [];

    // 앞의 빈 공간 채우기
    for (int i = 0; i < firstWeekDay - 1; i++) {
      dayWidgets.add(Container());
    }

    // 각 날짜 위젯
    for (int i = 1; i <= daysInMonth; i++) {
      final currentDate = DateTime(_selectedDate.year, _selectedDate.month, i);
      bool isToday = currentDate.day == DateTime.now().day &&
          currentDate.month == DateTime.now().month &&
          currentDate.year == DateTime.now().year;

      bool hasDiary = _cachedDiaryDates[_selectedDate.year.toString() +
                  "-" +
                  _selectedDate.month.toString()]
              ?.any((date) =>
                  date.year == currentDate.year &&
                  date.month == currentDate.month &&
                  date.day == currentDate.day) ??
          false;

      String? emotion = _diaryEmotions[currentDate]; //감정 가져오기

      // 감정에 맞는 이미지가 있는지 확인하고, 있으면 표시
      Widget emotionWidget;
      if (emotion != null && emotionImageMap.containsKey(emotion)) {
        emotionWidget = Image.asset(
          emotionImageMap[emotion]!, // 감정에 맞는 이미지 경로 사용
          width: 24.w, // 이미지 크기 조정
          height: 24.h,
        );
      } else {
        emotionWidget = Text('', style: TextStyle(fontSize: 16)); // 기본 이모티콘
      }

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            print("선택한 날짜: $currentDate");
            DateTime selectedDate =
                DateTime(currentDate.year, currentDate.month, currentDate.day);
            _selectDate(selectedDate);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                  height: 40.h, // 원하는 고정 높이
                  width: 40.w, // 원하는 고정 너비
                  decoration: BoxDecoration(
                    color: isToday
                        ? Colors.red
                        : hasDiary
                            ? Colors.green
                            : Colors.grey[200], // 일기가 있는 날 녹색 표시
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: emotionWidget,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                i.toString(),
                style: TextStyle(fontFamily: 'SuitRegular', fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 7,
      mainAxisSpacing: 8.h,
      crossAxisSpacing: 12.w,
      childAspectRatio: 0.65,
      children: dayWidgets,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:samsisegi/custom_component/custom_bottom_navigation_bar.dart';
import 'package:samsisegi/design_system.dart';
import 'package:samsisegi/diary_data/diary_entry.dart';

class MyPage extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  const MyPage({super.key, required this.onDateSelected});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _diaryDates = [];

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

  Future<void> _loadDiaryDates() async {
    final box = await Hive.openBox<DiaryEntry>('diaryBox');
    List<DateTime> diaryDates = [];

    for (var key in box.keys) {
      // Hive의 키는 'yyyy-MM-dd_period' 형식이므로 날짜만 추출
      String dateStr = key.split('_')[0];
      DateTime diaryDate = DateFormat('yyyy-MM-dd').parse(dateStr);

      if (!diaryDates.contains(diaryDate)) {
        diaryDates.add(diaryDate); // 중복된 날짜는 추가하지 않음
      }
    }

    setState(() {
      _diaryDates = diaryDates;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            _buildDivider(),
            SizedBox(height: 40.h),
            _buildMonthSelector(),
            Expanded(
              child: _buildCalendar(),
            ),
          ],
        ),
      ),
    );
  }

  Divider _buildDivider() => Divider(color: Colors.black, height: 1.h);

  Widget _buildMonthSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              setState(() {
                _selectedDate =
                    DateTime(_selectedDate.year, _selectedDate.month - 1, 1);
              });
            },
          ),
          Text(
            DateFormat('MMM yyyy').format(_selectedDate),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: () {
              setState(() {
                _selectedDate =
                    DateTime(_selectedDate.year, _selectedDate.month + 1, 1);
              });
            },
          ),
        ],
      ),
    );
  }

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
      bool hasDiary = _diaryDates.any((date) =>
          date.year == currentDate.year &&
          date.month == currentDate.month &&
          date.day == currentDate.day);

      dayWidgets.add(
        GestureDetector(
          onTap: () {
            print("선택한 날짜: $currentDate");
            DateTime selectedDate =
                DateTime(currentDate.year, currentDate.month, currentDate.day);
            _selectDate(selectedDate);
          },
          child: Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color:
                  hasDiary ? Colors.green : Colors.grey[200], // 일기가 있는 날 녹색 표시
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              i.toString(),
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      children: dayWidgets,
    );
  }
}

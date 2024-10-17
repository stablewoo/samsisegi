import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateSection extends StatelessWidget {
  final DateTime currentDate;
  const DateSection({super.key, required this.currentDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('MMM dd').format(currentDate),
          style: TextStyle(
            color: Colors.black,
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
                DateFormat('yyyy').format(currentDate),
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'SuitSemiBold',
                  fontSize: 64.sp,
                  height: 1,
                  wordSpacing: 64 * -0.02,
                ),
              ),
            ),
            Spacer(),
            Text(
              '/${DateFormat('EEE').format(currentDate)}',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: 'SuitRegular',
                fontSize: 32.sp,
                height: 45 / 32,
                wordSpacing: -0.64,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

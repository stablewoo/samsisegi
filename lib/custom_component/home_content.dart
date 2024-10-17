import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:samsisegi/design_system.dart';

class HomeContent extends StatelessWidget {
  final String timeText;
  final String titleText;
  final String contentText;

  const HomeContent(
      {super.key,
      required this.timeText,
      required this.titleText,
      required this.contentText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timeText, // 파라미터로 전달된 텍스트 사용
              style: TextStyle(
                color: AppColors.gray,
                fontFamily: 'SuitRegular',
                fontSize: 16.sp,
                height: 1,
                wordSpacing: -0.32,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              titleText, // 파라미터로 전달된 텍스트 사용
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: 'SuitBold',
                fontSize: 24.sp,
                height: 1,
                wordSpacing: -0.48,
              ),
            ),
            Spacer(),
            SvgPicture.asset(
              'assets/icons/right_arrow_20.svg',
              width: 20.w,
              height: 20.h,
            )
          ],
        ),
        SizedBox(height: 16.h),
        Center(
          child: SizedBox(
            width: 265.w,
            height: 45.h,
            child: Text(
              contentText, // 파라미터로 전달된 텍스트 사용
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: 'SuitRegular',
                fontSize: 12.sp,
                height: 16 / 12,
                letterSpacing: -0.24,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        SizedBox(height: 32.h),
        Container(
          width: double.infinity,
          height: 1.h,
          color: Colors.black,
        ),
      ],
    );
  }
}

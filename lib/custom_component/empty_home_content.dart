import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:samsisegi/design_system.dart';

class EmptyHomeContent extends StatelessWidget {
  final String timeText;
  final String contentText;
  final Color timeColor;
  final VoidCallback? onTap;

  const EmptyHomeContent({
    super.key,
    required this.timeText,
    required this.contentText,
    required this.timeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
              const Spacer(),
              SvgPicture.asset(
                'assets/icons/right_arrow_20.svg',
                color: timeColor,
                width: 20.w,
                height: 20.h,
              )
            ],
          ),
          SizedBox(height: 24.h),
          Center(
            child: SizedBox(
              width: 265.w,
              child: Text(
                contentText, // 파라미터로 전달된 텍스트 사용
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: timeColor,
                  fontFamily: 'SuitMedium',
                  fontSize: 24.sp,
                  height: 1,
                  wordSpacing: -0.48,
                ),
              ),
            ),
          ),
          SizedBox(height: 48.h),
          Container(
            width: double.infinity,
            height: 1.h,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmotionSelectBox extends StatelessWidget {
  final String imagePath;
  final String emotionText;

  const EmotionSelectBox({
    super.key,
    required this.emotionText,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFE4E4E4), borderRadius: BorderRadius.circular(16.r)),
      height: 104.h,
      width: 104.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 32.w,
            height: 32.h,
          ),
          SizedBox(height: 12.h),
          Text(emotionText),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:samsisegi/design_system.dart';

class EmotionSelectBox extends StatelessWidget {
  final String imagePath;
  final String emotionText;
  final bool isSelected;
  final Function onTap;

  const EmotionSelectBox({
    super.key,
    required this.emotionText,
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(), // 상위에서 전달된 onTap 호출
      splashColor: Colors.grey.withOpacity(0.5),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.enable
              : Color(0xFFE4E4E4), // 선택 여부에 따라 색상 변경
          borderRadius: BorderRadius.circular(16.r),
        ),
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
            Text(
              emotionText,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.primary,
                fontFamily: 'SuitRegular',
                fontSize: 12.sp,
                height: 1,
                wordSpacing: -0.24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:samsisegi/design_system.dart';

class PrimaryButtonH48 extends StatelessWidget {
  final String text;
  final bool isEnable;
  final VoidCallback onPressed;

  const PrimaryButtonH48({
    super.key,
    required this.text,
    required this.isEnable,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isEnable ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnable ? AppColors.enable : AppColors.disable,
        minimumSize: Size(double.infinity, 48.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.white,
          fontFamily: 'SuitSemiBold',
          fontSize: 18.sp,
          height: 24 / 18,
        ),
      ),
    );
  }
}

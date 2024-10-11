import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  static const Color primary = Color(0xFF1A1A1A);
  static const Color enable = Color(0xFF373737);
  static const Color disable = Color(0xFFD3D3D3);
  static const Color pressed = Color(0xFF1E1E1E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray = Color(0xFFA6A6A6);
}

class AppTextStyles {
  static TextStyle header24 = TextStyle(
    color: AppColors.primary,
    fontSize: 24.sp,
    fontFamily: 'SuitBold',
    height: 29 / 24,
    letterSpacing: -0.48,
  );

  static TextStyle subtitle14 = TextStyle(
    color: AppColors.gray,
    fontSize: 14.sp,
    fontFamily: 'SuitSemiBold',
    height: 16 / 14,
    letterSpacing: -0.28,
  );

  static TextStyle appBarSemiBold = TextStyle(
    color: AppColors.primary,
    fontSize: 16.sp,
    fontFamily: 'SuitSemiBold',
    height: 24 / 16,
    letterSpacing: -0.32,
  );

  static TextStyle appBarExtraLight = TextStyle(
    color: AppColors.primary,
    fontSize: 16.sp,
    fontFamily: 'SuitExtraLight',
    height: 16 / 14,
    letterSpacing: -0.32,
  );
}

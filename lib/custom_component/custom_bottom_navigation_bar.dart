import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:samsisegi/design_system.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  Widget _buildNavItem(String iconPath, String label, int index) {
    final bool isSelected = currentIndex == index;
    final Color iconColor = isSelected ? AppColors.enable : AppColors.disable;
    final TextStyle textStyle = TextStyle(
      color: isSelected ? AppColors.enable : AppColors.disable,
      fontSize: 12.sp,
      fontFamily: 'SuitRegular',
    );

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            color: iconColor,
            width: 18.w,
            height: 18.h,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: textStyle,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 36.5.w, right: 28.w),
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFECECEC),
            width: 1.w,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(
            'assets/icons/edit_calendar_18.svg',
            '내 일기',
            0,
          ),
          _buildNavItem(
            'assets/icons/add_18.svg',
            '일기쓰기',
            1,
          ),
          _buildNavItem(
            'assets/icons/person_18.svg',
            '마이페이지',
            2,
          ),
        ],
      ),
    );
  }
}

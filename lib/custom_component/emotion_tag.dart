import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:samsisegi/design_system.dart';

class HappyEmotionTag extends StatefulWidget {
  const HappyEmotionTag({super.key});

  @override
  State<HappyEmotionTag> createState() => _HappyEmotionTagState();
}

class _HappyEmotionTagState extends State<HappyEmotionTag> {
  final List<String> tags = [
    '신남',
    '기쁨',
    '행복함',
    '열정적인',
    '자랑스러움',
    '놀람',
    '재미있음',
    '희망적임',
    '자신 있음',
    '만족스러움',
    '감사',
    '안도',
    '평온',
    '차분'
  ];
  final List<String> selectedTags = [];

  void _onTagTapped(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 12.h,
      children: tags.map((tag) {
        final isSelected = selectedTags.contains(tag);
        return GestureDetector(
          onTap: () => _onTagTapped(tag),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.disable),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Text(
              tag,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.gray,
                fontFamily: 'SuitMedium',
                fontSize: 15.sp,
                height: 20 / 15,
                wordSpacing: -0.30,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class SosoEmotionTags extends StatefulWidget {
  const SosoEmotionTags({super.key});

  @override
  State<SosoEmotionTags> createState() => _SosoEmotionTagsState();
}

class _SosoEmotionTagsState extends State<SosoEmotionTags> {
  final List<String> tags = ['차분함', '평온함', '충족감 느낌', '무관심함', '지침'];
  final List<String> selectedTags = [];

  void _onTagTapped(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 12.h,
      children: tags.map((tag) {
        final isSelected = selectedTags.contains(tag);
        return GestureDetector(
          onTap: () => _onTagTapped(tag),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.disable),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Text(
              tag,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.gray,
                fontFamily: 'SuitMedium',
                fontSize: 15.sp,
                height: 20 / 15,
                wordSpacing: -0.30,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class BadEmotionTags extends StatefulWidget {
  const BadEmotionTags({super.key});

  @override
  State<BadEmotionTags> createState() => _BadEmotionTagsState();
}

class _BadEmotionTagsState extends State<BadEmotionTags> {
  final List<String> tags = [
    '화남',
    '불안함',
    '당황스러움',
    '무서움',
    '부끄러움',
    '좌절스러움',
    '역겨움',
    '짜증',
    '스트레스',
    '지침',
    '실망',
    '슬픔',
    '낙심',
    '죄책감',
    '부러움',
    '외로움'
  ];
  final List<String> selectedTags = [];

  void _onTagTapped(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 12.h,
      children: tags.map((tag) {
        final isSelected = selectedTags.contains(tag);
        return GestureDetector(
          onTap: () => _onTagTapped(tag),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.disable),
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Text(
              tag,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.gray,
                fontFamily: 'SuitMedium',
                fontSize: 15.sp,
                height: 20 / 15,
                wordSpacing: -0.30,
              ),
            ),
          ),
        );
      }).toList(),
    );
    ;
  }
}

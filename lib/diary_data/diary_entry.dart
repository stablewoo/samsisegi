import 'package:hive/hive.dart';

part 'diary_entry.g.dart';

@HiveType(typeId: 0)
class DiaryEntry extends HiveObject {
  @HiveField(0)
  String date; // 날짜

  @HiveField(1)
  String period; // 아침, 오후, 저녁

  @HiveField(2)
  String title; // 제목

  @HiveField(3)
  String content; // 내용

  @HiveField(4)
  String emotion; // 선택한 감정

  @HiveField(5)
  List<String> tags; // 선택한 태그 리스트

  DiaryEntry({
    required this.date,
    required this.period,
    required this.title,
    required this.content,
    required this.emotion,
    required this.tags,
  });
}

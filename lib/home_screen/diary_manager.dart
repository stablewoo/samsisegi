import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../diary_data/diary_entry.dart';

class DiaryManager {
  static Future<Map<String, DiaryEntry?>> loadEntries(
      DateTime currentDate) async {
    final box = await Hive.openBox<DiaryEntry>('diaryBox');
    Map<String, DiaryEntry?> entries = {};

    for (var period in ['morning', 'afternoon', 'night']) {
      String key = '${DateFormat('yyyy-MM-dd').format(currentDate)}_$period';
      final entry = box.get(key);
      entries[period] = entry;
    }

    return entries;
  }
}

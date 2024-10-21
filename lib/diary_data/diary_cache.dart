import 'package:hive/hive.dart';
import 'package:samsisegi/diary_data/diary_entry.dart';

class DiaryCache {
  static Map<String, DiaryEntry> cachedEntries = {};

  // 로컬 저장소에서 일기 데이터를 불러오는 메서드
  static Future<void> loadEntries() async {
    final box = await Hive.openBox<DiaryEntry>('diaryBox');
    cachedEntries.clear();

    for (var key in box.keys) {
      // key는 'yyyy-MM-dd_period' 형식으로 저장
      DiaryEntry? entry = box.get(key);
      if (entry != null) {
        cachedEntries[key] = entry; // key는 '날짜_기간' 형식
        print('캐싱된 데이터: $key');
      }
    }
  }

  // 캐시에서 일기 가져오기
  static DiaryEntry? getEntry(String date, String period) {
    String key = '${date}_$period';
    if (cachedEntries.containsKey(key)) {
      print('캐시에서 데이터 가져옴: $key'); // 캐시에서 불러올 때 출력
      return cachedEntries[key];
    } else {
      print('캐시에 데이터 없음. 로컬에서 불러와야 함: $key'); // 캐시에 없을 때 출력
      return null;
    }
  }

  // 새로운 일기 추가 및 캐시 업데이트
  static void addOrUpdateEntry(String date, String period, DiaryEntry entry) {
    String key = '${date}_$period';
    cachedEntries[key] = entry;
  }

  // 특정 일기 삭제
  static void deleteEntry(String date, String period) {
    String key = '${date}_$period';
    cachedEntries.remove(key);
  }
}

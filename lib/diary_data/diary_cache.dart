import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:samsisegi/diary_data/diary_entry.dart';

class DiaryCache {
  static Map<String, List<DiaryEntry>> cachedEntries = {};

  // 로컬 저장소에서 일기 데이터를 불러오는 메서드
  static Future<void> loadMonthlyEntries(String yearMonth) async {
    final box = await Hive.openBox<DiaryEntry>('diaryBox');
    cachedEntries.remove(yearMonth);
    cachedEntries[yearMonth] = [];

    for (var key in box.keys) {
      // key가 'yyyy-MM-dd_period' 형식이므로 'yyyy-MM'을 추출해 월 단위로 비교
      if (key.startsWith(yearMonth)) {
        DiaryEntry? entry = box.get(key);
        if (entry != null) {
          cachedEntries[yearMonth]?.add(entry);
        }
      }
    }
    print('캐싱된 $yearMonth 데이터: ${cachedEntries[yearMonth]?.length}개');
  }

  // 특정 월의 일기 데이터 가져오기
  static List<DiaryEntry>? getMonthlyEntries(String yearMonth) {
    if (cachedEntries.containsKey(yearMonth)) {
      print('캐시에서 $yearMonth 데이터를 가져옴');
      return cachedEntries[yearMonth];
    } else {
      print('$yearMonth 데이터가 캐시에 없음. 로컬에서 불러와야 함.');
      return null;
    }
  }

  // 일기를 저장한 후 캐시 업데이트
  static Future<void> updateCache(DiaryEntry newDiary) async {
    String yearMonth =
        DateFormat('yyyy-MM').format(DateTime.parse(newDiary.date));

    // 캐시에 해당 월 데이터가 있는지 확인
    List<DiaryEntry>? monthlyEntries = cachedEntries[yearMonth];

    if (monthlyEntries == null) {
      // 해당 월 데이터가 캐시에 없으면 새로 로드
      await loadMonthlyEntries(yearMonth);
      monthlyEntries = cachedEntries[yearMonth];
    }

    // 해당 월의 데이터를 업데이트
    int existingIndex = monthlyEntries!.indexWhere((entry) =>
        entry.date == newDiary.date && entry.period == newDiary.period);

    if (existingIndex != -1) {
      // 기존 일기가 있으면 업데이트
      monthlyEntries[existingIndex] = newDiary;
    } else {
      // 없으면 새로 추가
      monthlyEntries.add(newDiary);
    }

    // 캐시에 업데이트된 데이터를 저장
    cachedEntries[yearMonth] = monthlyEntries;
    print('$yearMonth 캐시 업데이트 완료');
  }
}

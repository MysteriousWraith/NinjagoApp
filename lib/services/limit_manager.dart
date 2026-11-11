import 'package:shared_preferences/shared_preferences.dart';

class LimitManager {
  static const String _viewsKey = 'daily_views_count';
  static const String _lastDateKey = 'last_view_date';
  static const String _isPremiumKey = 'is_premium_unlocked';

  // Лимит бесплатных просмотров в день
  static const int dailyLimit = 4;

  // Проверка, есть ли премиум
  static Future<bool> isPremium() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isPremiumKey) ?? false;
  }

  // Активация премиум-ключа
  static Future<void> unlockPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isPremiumKey, true);
  }

  // Проверка и инкремент лимита просмотров
  static Future<bool> canWatchEpisode() async {
    if (await isPremium()) return true;

    final prefs = await SharedPreferences.getInstance();
    final today = _getDateString(DateTime.now());
    final lastDate = prefs.getString(_lastDateKey) ?? '';

    int views = prefs.getInt(_viewsKey) ?? 0;

    // Если наступил новый день — сбрасываем счетчик
    if (lastDate != today) {
      views = 0;
      await prefs.setString(_lastDateKey, today);
      await prefs.setInt(_viewsKey, 0);
    }

    return views < dailyLimit;
  }

  // Зафиксировать просмотр серии
  static Future<void> registerView() async {
    if (await isPremium()) return;

    final prefs = await SharedPreferences.getInstance();
    int views = prefs.getInt(_viewsKey) ?? 0;
    await prefs.setInt(_viewsKey, views + 1);
  }

  // Получить оставшиеся попытки на сегодня
  static Future<int> getRemainingViews() async {
    if (await isPremium()) return 999;

    final prefs = await SharedPreferences.getInstance();
    final today = _getDateString(DateTime.now());
    final lastDate = prefs.getString(_lastDateKey) ?? '';

    if (lastDate != today) return dailyLimit;

    int views = prefs.getInt(_viewsKey) ?? 0;
    return (dailyLimit - views).clamp(0, dailyLimit);
  }

  static String _getDateString(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}

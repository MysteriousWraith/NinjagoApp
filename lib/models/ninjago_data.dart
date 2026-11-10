import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  static const String _key = 'favorite_episodes';

  // Зберегти список обраних
  static Future<void> saveFavorites(List<Episode> allEpisodes) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = allEpisodes
        .where((ep) => ep.isFavorite)
        .map((ep) => '${ep.season}_${ep.number}')
        .toList();
    await prefs.setStringList(_key, favoriteIds);
  }

  // Завантажити статус обраних
  static Future<void> loadFavorites(List<Episode> allEpisodes) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_key) ?? [];
    
    for (var ep in allEpisodes) {
      final id = '${ep.season}_${ep.number}';
      ep.isFavorite = favoriteIds.contains(id);
    }
  }
}

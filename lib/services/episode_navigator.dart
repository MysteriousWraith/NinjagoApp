import 'package:flutter/material.dart';
import 'limit_manager.dart';
import '../models/ninjago_data.dart';
import '../screens/video_player_screen.dart';
import '../screens/wisdom_scroll_screen.dart';

class EpisodeNavigator {
  static Future<void> openEpisode(
    BuildContext context, {
    required Episode episode,
    required Function(String, String) onWatch,
  }) async {
    // Проверяем, разрешен ли просмотр (лимит или премиум)
    bool allowed = await LimitManager.canWatchEpisode();

    if (allowed) {
      // Засчитываем просмотр и открываем плеер
      await LimitManager.registerView();
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(
              episode: episode,
              onWatch: onWatch,
            ),
          ),
        );
      }
    } else {
      // Лимит исчерпан — показываем Свиток Мудрости Сенсея Ву
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WisdomScrollScreen(),
          ),
        );
      }
    }
  }
}

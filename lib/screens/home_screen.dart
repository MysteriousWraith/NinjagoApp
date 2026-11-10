import 'package:flutter/material.dart';
import 'dart:math';
import '../models/ninjago_data.dart';
import 'video_player_screen.dart';
import 'widgets.dart';

class HomeScreen extends StatelessWidget {
  final bool isPremium;
  final int watchedCount;
  final String lastWatchedSeason;
  final String lastWatchedTitle;
  final Function(String, String) onWatch;

  const HomeScreen({
    super.key,
    required this.isPremium,
    required this.watchedCount,
    required this.lastWatchedSeason,
    required this.lastWatchedTitle,
    required this.onWatch,
  });

  void _timeRollback(BuildContext context) {
    final randomEpisode = episodesArchive[Random().nextInt(episodesArchive.length)];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B1B22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.history_rounded, color: Colors.amber),
            SizedBox(width: 8),
            Text('Откат Часу! ⏳'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Сенсей Ву перегорнув пісочний годинник! Випадкова серія:'),
            const SizedBox(height: 12),
            Text('${randomEpisode.season} - ${randomEpisode.number}\n«${randomEpisode.title}»', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, fontSize: 16)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Закрити')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, foregroundColor: Colors.black),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoPlayerScreen(episode: randomEpisode, onWatch: onWatch)),
              );
            },
            child: const Text('Дивитися'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final quote = senseiQuotes[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('NINJAGO: Архів', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 22)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Откат часу',
            onPressed: () => _timeRollback(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B22),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryColor.withOpacity(0.5), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_book_rounded, color: primaryColor, size: 22),
                    const SizedBox(width: 10),
                    Text('Свиток Мудрості Сенсея Ву', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 10),
                Text('"${quote.quote}"', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13, color: Colors.white70, height: 1.3)),
                const SizedBox(height: 6),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('— ${quote.author}', style: TextStyle(color: primaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B22),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryColor.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.black, size: 30),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Продовжити перегляд', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(height: 2),
                      Text(lastWatchedSeason, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text(lastWatchedTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios_rounded, color: primaryColor, size: 18),
                  onPressed: () {
                    final ep = episodesArchive.firstWhere((e) => e.title == lastWatchedTitle, orElse: () => episodesArchive[0]);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(episode: ep, onWatch: onWatch)));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B22),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: primaryColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('👑 Статус: Премиум Безліміт', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                    const SizedBox(height: 4),
                    Text('Переглянуто серій для прогресу: $watchedCount', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text('Останні поступлення', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...episodesArchive.take(4).map((ep) => EpisodeCard(episode: ep, onPlayPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(episode: ep, onWatch: onWatch)));
          })),
        ],
      ),
    );
  }
}

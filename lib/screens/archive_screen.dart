import 'package:flutter/material.dart';
import '../models/ninjago_data.dart';
import 'video_player_screen.dart';
import 'widgets.dart';

class SeasonsCatalogScreen extends StatelessWidget {
  final Function(String, String) onWatch;

  const SeasonsCatalogScreen({super.key, required this.onWatch});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Архів Сезонів (0–15)', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allSeasons.length,
        itemBuilder: (context, index) {
          final s = allSeasons[index];
          return Card(
            color: const Color(0xFF1B1B22),
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: primaryColor.withOpacity(0.15))),
            child: ListTile(
              title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${s.year} • ${s.episodeCount} серій • 1080p Дубляж', style: const TextStyle(color: Colors.grey, fontSize: 12)),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: primaryColor),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SeasonDetailScreen(season: s, onWatch: onWatch)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class SeasonDetailScreen extends StatelessWidget {
  final SeasonInfo season;
  final Function(String, String) onWatch;

  const SeasonDetailScreen({super.key, required this.season, required this.onWatch});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(season.title, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Серії сезону (${season.episodes.length})', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 12),
          ...season.episodes.map((ep) => EpisodeCard(
            episode: ep,
            onPlayPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(episode: ep, onWatch: onWatch)));
            },
          )),
        ],
      ),
    );
  }
}

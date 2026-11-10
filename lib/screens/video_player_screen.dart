import 'package:flutter/material.dart';
import '../models/ninjago_data.dart';

class VideoPlayerScreen extends StatelessWidget {
  final Episode episode;
  final Function(String, String) onWatch;

  const VideoPlayerScreen({super.key, required this.episode, required this.onWatch});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(episode.title, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 220,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.movie_rounded, size: 64, color: Colors.white24),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: primaryColor,
                  child: IconButton(
                    icon: const Icon(Icons.play_arrow_rounded, color: Colors.black, size: 36),
                    onPressed: () {
                      onWatch(episode.season, episode.title);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Відтворення запущено (1080p • Дубляж)')),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 16,
                  right: 16,
                  child: LinearProgressIndicator(
                    value: 0.35,
                    color: primaryColor,
                    backgroundColor: Colors.white24,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${episode.season} • ${episode.number}', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(episode.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('${episode.duration} | ${episode.quality}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 16),
                const Text('Опис серії:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                Text(episode.description, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

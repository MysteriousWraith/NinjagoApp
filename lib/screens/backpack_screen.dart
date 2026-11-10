import 'package:flutter/material.dart';
import '../models/ninjago_data.dart';
import 'widgets.dart';

class BackpackScreen extends StatelessWidget {
  const BackpackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final downloaded = episodesArchive.where((e) => e.isDownloaded).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Офлайн-Рюкзак', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: downloaded.isEmpty
          ? const Center(child: Text('Рюкзак порожній.', style: TextStyle(color: Colors.grey)))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: downloaded.map((ep) => EpisodeCard(episode: ep)).toList(),
            ),
    );
  }
}

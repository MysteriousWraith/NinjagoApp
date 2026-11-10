import 'package:flutter/material.dart';
import '../models/ninjago_data.dart';

class EpisodeCard extends StatelessWidget {
  final Episode episode;
  final VoidCallback? onPlayPressed;

  const EpisodeCard({super.key, required this.episode, this.onPlayPressed});

  @override
  Widget build(BuildContext context) {
    final primaryModelColor = Theme.of(context).primaryColor;

    return Card(
      color: const Color(0xFF1B1B22),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: primaryModelColor.withOpacity(0.2))),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primaryModelColor,
          child: IconButton(
            icon: const Icon(Icons.play_arrow_rounded, color: Colors.black),
            onPressed: onPlayPressed,
          ),
        ),
        title: Text('${episode.number}: ${episode.title}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${episode.duration} • ${episode.quality}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(episode.isDownloaded ? Icons.download_done : Icons.download_outlined, color: Colors.grey, size: 20),
            const SizedBox(width: 8),
            Icon(episode.isFavorite ? Icons.bookmark : Icons.bookmark_border, color: primaryModelColor),
          ],
        ),
        onTap: onPlayPressed,
      ),
    );
  }
}

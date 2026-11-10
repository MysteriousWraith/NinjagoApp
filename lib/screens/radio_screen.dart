import 'package:flutter/material.dart';

class RadioScreen extends StatefulWidget {
  const RadioScreen({super.key});

  @override
  State<RadioScreen> createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  bool isPlaying = false;
  String currentTrack = 'The Weekend Whip (Classic Mix)';

  final List<String> tracks = [
    'The Weekend Whip (Classic Mix)',
    'The Pirate Whip (Season 6)',
    'The Falcon Whip (Zane Theme)',
    'Ghost Whip (Season 5)',
    'The Rift Whip (Dragons Rising Style)',
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Радіо Монастиря', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1B1B22),
                border: Border.all(color: primaryColor.withOpacity(0.6), width: 3),
                boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.2), blurRadius: 20, spreadRadius: 5)],
              ),
              child: Icon(Icons.music_note_rounded, size: 64, color: primaryColor),
            ),
            const SizedBox(height: 30),
            Text('Зараз грає:', style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
            const SizedBox(height: 8),
            Text(currentTrack, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.skip_previous_rounded),
                  color: primaryColor,
                  onPressed: () {
                    setState(() {
                      int index = tracks.indexOf(currentTrack);
                      currentTrack = tracks[(index - 1 + tracks.length) % tracks.length];
                    });
                  },
                ),
                const SizedBox(width: 20),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: primaryColor,
                  child: IconButton(
                    iconSize: 32,
                    icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.black),
                    onPressed: () => setState(() => isPlaying = !isPlaying),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  iconSize: 36,
                  icon: const Icon(Icons.skip_next_rounded),
                  color: primaryColor,
                  onPressed: () {
                    setState(() {
                      int index = tracks.indexOf(currentTrack);
                      currentTrack = tracks[(index + 1) % tracks.length];
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

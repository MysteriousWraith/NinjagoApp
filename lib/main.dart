import 'package:flutter/material.dart';

void main() {
  runApp(const NinjagoApp());
}

class NinjagoApp extends StatelessWidget {
  const NinjagoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LEGO Ninjago Архів',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFFFFD700),
      ),
      home: const MainScreen(),
    );
  }
}

class EpisodeItem {
  final int number;
  final String titleUk;
  final String durationText;

  EpisodeItem({
    required this.number,
    required this.titleUk,
    required this.durationText,
  });
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<EpisodeItem> episodes = [
      EpisodeItem(number: 1, titleUk: 'Шлях Ніндзя', durationText: '21 хв • Український дубляж (1080p)'),
      EpisodeItem(number: 2, titleUk: 'Зброя Зі Сходу', durationText: '21 хв • Український дубляж (1080p)'),
      EpisodeItem(number: 3, titleUk: 'Король Тіней', durationText: '21 хв • Український дубляж (1080p)'),
      EpisodeItem(number: 4, titleUk: 'Укус Змії', durationText: '21 хв • Український дубляж (1080p)'),
    ];

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverAppBar(
                floating: true,
                backgroundColor: Color(0xFF121212),
                title: Text(
                  'LEGO NINJAGO: Архів',
                  style: TextStyle(
                    color: Color(0xFFFFD700),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final episode = episodes[index];
                      return EpisodeCard(episode: episode);
                    },
                    childCount: episodes.length,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: ContinueWatchingCard(
              seasonEpisode: 'Сезон 1 • Серія 3',
              timeCode: 'Таймкод: 04:12 / 21:30',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class EpisodeCard extends StatelessWidget {
  final EpisodeItem episode;

  const EpisodeCard({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.play_arrow_rounded,
            color: Color(0xFFFFD700),
            size: 28,
          ),
        ),
        title: Text(
          'Серія ${episode.number}',
          style: const TextStyle(
            color: Color(0xFFFFD700),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              episode.titleUk,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              episode.durationText,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}

class ContinueWatchingCard extends StatelessWidget {
  final String seasonEpisode;
  final String timeCode;
  final VoidCallback onTap;

  const ContinueWatchingCard({
    super.key,
    required this.seasonEpisode,
    required this.timeCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1E1E1E),
      borderRadius: BorderRadius.circular(16),
      elevation: 8,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.play_arrow, color: Color(0xFFFFD700)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Продовжити перегляд',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      seasonEpisode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeCode,
                      style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

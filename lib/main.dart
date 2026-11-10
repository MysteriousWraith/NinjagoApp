import 'package:flutter/material.dart';

void main() {
  runApp(const NinjagoArchiveApp());
}

class NinjagoArchiveApp extends StatelessWidget {
  const NinjagoArchiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LEGO Ninjago Архів',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFFFFC107),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFC107),
          surface: Color(0xFF1E1E1E),
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainContainer(),
    );
  }
}

// Главный контейнер с нижней навигацией
class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SeasonsScreen(),
    const FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF181818),
        selectedItemColor: const Color(0xFFFFC107),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Головна',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Сезони',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Обране',
          ),
        ],
      ),
    );
  }
}

// Модель данных для серии
class Episode {
  final String season;
  final String number;
  final String title;
  final String duration;
  final String quality;
  bool isFavorite;

  Episode({
    required this.season,
    required this.number,
    required this.title,
    required this.duration,
    required this.quality,
    this.isFavorite = false,
  });
}

// Глобальный список серий для демонстрации
List<Episode> episodesList = [
  Episode(season: 'Сезон 1', number: 'Серія 1', title: 'Шлях Ніндзя', duration: '21 хв', quality: 'Український дубляж (1080p)', isFavorite: true),
  Episode(season: 'Сезон 1', number: 'Серія 2', title: 'Зброя Зі Сходу', duration: '21 хв', quality: 'Український дубляж (1080p)'),
  Episode(season: 'Сезон 1', number: 'Серія 3', title: 'Король Тіней', duration: '21 хв', quality: 'Український дубляж (1080p)', isFavorite: true),
  Episode(season: 'Сезон 1', number: 'Серія 4', title: 'Укус Змії', duration: '21 хв', quality: 'Український дубляж (1080p)'),
];

// 1. Главный экран
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LEGO NINJAGO: Архів', style: TextStyle(color: Color(0xFFFFC107), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Останні поступлення', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...episodesList.map((ep) => EpisodeCard(episode: ep)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Продовжити перегляд', style: TextStyle(color: Colors.grey, fontSize: 14)),
                SizedBox(height: 8),
                Text('Сезон 1 • Серія 3: Король Тіней', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Таймкод: 04:12 / 21:30', style: TextStyle(color: Color(0xFFFFC107), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Карточка серии с возможностью добавления в избранное
class EpisodeCard extends StatefulWidget {
  final Episode episode;
  const EpisodeCard({super.key, required this.episode});

  @override
  State<EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<EpisodeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFFFFC107),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.play_arrow, color: Colors.black, size: 30),
        ),
        title: Text('${widget.episode.number}: ${widget.episode.title}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text('${widget.episode.duration} • ${widget.episode.quality}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ),
        trailing: IconButton(
          icon: Icon(
            widget.episode.isFavorite ? Icons.bookmark : Icons.bookmark_border,
            color: const Color(0xFFFFC107),
          ),
          onPressed: () {
            setState(() {
              widget.episode.isFavorite = !widget.episode.isFavorite;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.episode.isFavorite ? 'Додано до обраного' : 'Видалено з обраного'),
                duration: const Duration(milliseconds: 800),
              ),
            );
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlayerScreen(episode: widget.episode)),
          );
        },
      ),
    );
  }
}

// 2. Экран выбора сезонов (Все 15 сезонов)
class SeasonsScreen extends StatelessWidget {
  const SeasonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Всі Сезони', style: TextStyle(color: Color(0xFFFFC107), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: 15,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final seasonNum = index + 1;
          return Card(
            color: const Color(0xFF1E1E1E),
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text('Сезон $seasonNum', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: const Text('Український дубляж • 1080p', style: TextStyle(color: Colors.grey, fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFFFC107)),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Відкриваємо Сезон $seasonNum')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// 3. Экран «Избранное»
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favoriteEpisodes = episodesList.where((e) => e.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Обране', style: TextStyle(color: Color(0xFFFFC107), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: favoriteEpisodes.isEmpty
          ? const Center(
              child: Text('Список обраного порожній', style: TextStyle(color: Colors.grey)),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: favoriteEpisodes.map((ep) => EpisodeCard(episode: ep)).toList(),
            ),
    );
  }
}

// 4. Экран плеера / детального просмотра серии
class PlayerScreen extends StatelessWidget {
  final Episode episode;
  const PlayerScreen({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(episode.title),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            color: Colors.black,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.play_circle_fill, size: 80, color: Color(0xFFFFC107)),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: LinearProgressIndicator(
                    value: 0.3,
                    color: const Color(0xFFFFC107),
                    backgroundColor: Colors.grey.withOpacity(0.3),
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
                Text('${episode.season} • ${episode.number}', style: const TextStyle(color: Color(0xFFFFC107), fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(episode.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('Якість: ${episode.quality}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                const Text(
                  'Опис епізоду: Головні герої вирушають у нову пригоду, щоб захистити Ніндзяго-Сіті від підступних ворогів та опанувати нові стихії.',
                  style: TextStyle(height: 1.4, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

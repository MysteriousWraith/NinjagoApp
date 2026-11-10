import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NinjagoArchiveApp());
}

// -----------------------------------------------------------------------------
// STYLES & ELEMENTAL THEMES (Стихії)
// -----------------------------------------------------------------------------
enum ElementTheme { energy, fire, ice, lightning, earth, water, garmadon }

class NinjagoArchiveApp extends StatefulWidget {
  const NinjagoArchiveApp({super.key});

  @override
  State<NinjagoArchiveApp> createState() => _NinjagoArchiveAppState();
}

class _NinjagoArchiveAppState extends State<NinjagoArchiveApp> {
  ElementTheme _currentElement = ElementTheme.energy;
  int _watchedCount = 1;
  String _lastWatchedTitle = 'Шлях Ніндзя';
  String _lastWatchedSeason = 'Пілотний сезон';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _watchedCount = prefs.getInt('watchedCount') ?? 1;
        _lastWatchedTitle = prefs.getString('lastWatchedTitle') ?? 'Шлях Ніндзя';
        _lastWatchedSeason = prefs.getString('lastWatchedSeason') ?? 'Пілотний сезон';
        
        final themeIndex = prefs.getInt('currentElement') ?? 0;
        if (themeIndex >= 0 && themeIndex < ElementTheme.values.length) {
          _currentElement = ElementTheme.values[themeIndex];
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveTheme(ElementTheme element) async {
    setState(() => _currentElement = element);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentElement', element.index);
  }

  Future<void> _updateProgress(String season, String title) async {
    setState(() {
      _watchedCount++;
      _lastWatchedSeason = season;
      _lastWatchedTitle = title;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('watchedCount', _watchedCount);
    await prefs.setString('lastWatchedSeason', season);
    await prefs.setString('lastWatchedTitle', title);
  }

  Color get primaryColor {
    switch (_currentElement) {
      case ElementTheme.fire:
        return const Color(0xFFFF3D00); // Кай
      case ElementTheme.ice:
        return const Color(0xFF00E5FF); // Зейн
      case ElementTheme.lightning:
        return const Color(0xFF2979FF); // Джей
      case ElementTheme.earth:
        return const Color(0xFFFF9100); // Коул
      case ElementTheme.water:
        return const Color(0xFF00B0FF); // Нія
      case ElementTheme.garmadon:
        return const Color(0xFFD500F9); // Тень Гармадона
      case ElementTheme.energy:
      default:
        return const Color(0xFF76FF03); // Ллойд
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: primaryColor),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'LEGO Ninjago Архів',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F14),
        primaryColor: primaryColor,
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          surface: const Color(0xFF1B1B22),
        ),
        fontFamily: 'Roboto',
      ),
      home: MainContainer(
        currentElement: _currentElement,
        onElementChanged: _saveTheme,
        watchedCount: _watchedCount,
        lastWatchedSeason: _lastWatchedSeason,
        lastWatchedTitle: _lastWatchedTitle,
        onEpisodeWatched: _updateProgress,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// MODELS & FULL SEASONS BASE (0–15)
// -----------------------------------------------------------------------------
class Episode {
  final String season;
  final String number;
  final String title;
  final String duration;
  final String quality;
  final String description;
  bool isFavorite;
  bool isDownloaded;

  Episode({
    required this.season,
    required this.number,
    required this.title,
    required this.duration,
    required this.quality,
    required this.description,
    this.isFavorite = false,
    this.isDownloaded = false,
  });
}

class SeasonInfo {
  final int number;
  final String title;
  final String year;
  final int episodeCount;
  final List<Episode> episodes;

  SeasonInfo({
    required this.number,
    required this.title,
    required this.year,
    required this.episodeCount,
    required this.episodes,
  });
}

class SenseiQuote {
  final String quote;
  final String author;
  SenseiQuote({required this.quote, required this.author});
}

final List<SenseiQuote> senseiQuotes = [
  SenseiQuote(quote: "Ніколи не відкладай на завтра те, що можна зробити сьогодні.", author: "Сенсей Ву"),
  SenseiQuote(quote: "Шлях до справжньої сили лежить через дисципліну та серце ніндзя.", author: "Сенсей Ву"),
  SenseiQuote(quote: "Учень вчить вчителя. Навіть найменший може змінити все.", author: "Сенсей Ву"),
  SenseiQuote(quote: "Ніндзя ніколи не здаються, коли вірять у своїх друзів.", author: "Сенсей Ву"),
];

final List<SeasonInfo> allSeasons = [
  SeasonInfo(
    number: 0,
    title: 'Пілотний сезон (Шлях Ніндзя)',
    year: '2011',
    episodeCount: 2,
    episodes: [
      Episode(season: 'Пілотний сезон', number: 'Серія 1', title: 'Шлях Ніндзя', duration: '22 хв', quality: '1080p • Дубляж', description: 'Коваля Кая відвідує загадковий старий ремісник Ву та пропонує стати ніндзя.', isFavorite: true, isDownloaded: true),
      Episode(season: 'Пілотний сезон', number: 'Серія 2', title: 'Зброя Зі Сходу', duration: '22 хв', quality: '1080p • Дубляж', description: 'Команда вирушає на пошуки чотирьох Золотих Зброй Спінжитсу.'),
    ],
  ),
  SeasonInfo(
    number: 1,
    title: 'Сезон 1: Воскресіння Змій',
    year: '2011-2012',
    episodeCount: 13,
    episodes: [
      Episode(season: 'Сезон 1', number: 'Серія 1', title: 'Воскресіння Змій', duration: '22 хв', quality: '1080p • Дубляж', description: 'Ллойд Гармадон випадково випускає давнє племя Зміїних Кланів.', isFavorite: true),
      Episode(season: 'Сезон 1', number: 'Серія 2', title: 'Дім', duration: '22 хв', quality: '1080p • Дубляж', description: 'Змії планують спалити монастир Спінжитсу.'),
    ],
  ),
  SeasonInfo(
    number: 2,
    title: 'Сезон 2: Спадщина Зеленого Ніндзя',
    year: '2012-2013',
    episodeCount: 13,
    episodes: [
      Episode(season: 'Сезон 2', number: 'Серія 1', title: 'Темрява Наступає', duration: '22 хв', quality: '1080p • Дубляж', description: 'Ніндзя тренують Ллойда для вирішальної битви.'),
      Episode(season: 'Сезон 2', number: 'Серія 2', title: 'Останнє Змагання', duration: '22 хв', quality: '1080p • Дубляж', description: 'Золотий Майстер розкриває свою справжню силу.'),
    ],
  ),
  SeasonInfo(number: 3, title: 'Сезон 3: Перезавантаження', year: '2014', episodeCount: 8, episodes: [Episode(season: 'Сезон 3', number: 'Серія 1', title: 'Вхід у Цифровий Світ', duration: '22 хв', quality: '1080p • Дубляж', description: 'Ніндзяго-Сіті перетворилося на високотехнологічний мегаполіс.')]),
  SeasonInfo(number: 4, title: 'Сезон 4: Турнір Стихій', year: '2015', episodeCount: 10, episodes: [Episode(season: 'Сезон 4', number: 'Серія 1', title: 'Запрошення Майстра Чена', duration: '22 хв', quality: '1080p • Дубляж', description: 'Ніндзя вирушають на таємничий острів Чена.')]),
  SeasonInfo(number: 5, title: 'Сезон 5: Одержимість', year: '2015', episodeCount: 10, episodes: [Episode(season: 'Сезон 5', number: 'Серія 1', title: 'Подих Вітру', duration: '22 хв', quality: '1080p • Дубляж', description: 'Привид Морро захоплює тіло Ллойда.')]),
  SeasonInfo(number: 6, title: 'Сезон 6: Небесні Пірати', year: '2016', episodeCount: 10, episodes: [Episode(season: 'Сезон 6', number: 'Серія 1', title: 'Печатка Небес', duration: '22 хв', quality: '1080p • Дубляж', description: 'Джинн Надахан повертається з ув’язнення.')]),
  SeasonInfo(number: 7, title: 'Сезон 7: Руки Часу', year: '2017', episodeCount: 10, episodes: [Episode(season: 'Сезон 7', number: 'Серія 1', title: 'Блискавична Атака', duration: '22 хв', quality: '1080p • Дубляж', description: 'Близнюки Часу Повертаються у Монастир.')]),
  SeasonInfo(number: 8, title: 'Сезон 8: Сини Гармадона', year: '2018', episodeCount: 10, episodes: [Episode(season: 'Сезон 8', number: 'Серія 1', title: 'Маска Обману', duration: '22 хв', quality: '1080p • Дубляж', description: 'Принцеса Харумі та бандити шукають Они-Маски.')]),
  SeasonInfo(number: 9, title: 'Сезон 9: Зацьковані', year: '2018', episodeCount: 10, episodes: [Episode(season: 'Сезон 9', number: 'Серія 1', title: 'Перше Королівство', duration: '22 хв', quality: '1080p • Дубляж', description: 'Ніндзя потрапляють у світ Драконів та Они.')]),
  SeasonInfo(number: 10, title: 'Сезон 10: Марш Они', year: '2019', episodeCount: 4, episodes: [Episode(season: 'Сезон 10', number: 'Серія 1', title: 'Наближення Темряви', duration: '22 хв', quality: '1080p • Дубляж', description: 'Они занурюють Ніндзяго-Сіті у вічну темряву.')]),
  SeasonInfo(number: 11, title: 'Сезон 11: Секрети Забороненого Спінжитсу', year: '2019-2020', episodeCount: 30, episodes: [Episode(season: 'Сезон 11', number: 'Серія 1', title: 'Вогняна Вуаля', duration: '11 хв', quality: '1080p • Дубляж', description: 'Пробудження полум’яної змії Асфіри.')]),
  SeasonInfo(number: 12, title: 'Сезон 12: Вищий Імперій', year: '2020', episodeCount: 16, episodes: [Episode(season: 'Сезон 12', number: 'Серія 1', title: 'Аркадний Світ', duration: '11 хв', quality: '1080p • Дубляж', description: 'Гравці зникають усередині старого ігрового автомата.')]),
  SeasonInfo(number: 13, title: 'Сезон 13: Майстер Гори', year: '2020', episodeCount: 16, episodes: [Episode(season: 'Сезон 13', number: 'Серія 1', title: 'Королівство Сінтаро', duration: '11 хв', quality: '1080p • Дубляж', description: 'Команда подорожує до підземних шахт Сінтаро.')]),
  SeasonInfo(number: 14, title: 'Сезон 14: Острів', year: '2021', episodeCount: 4, episodes: [Episode(season: 'Сезон 14', number: 'Серія 1', title: 'Таємниця Храму', duration: '11 хв', quality: '1080p • Дубляж', description: 'Ніндзя вирушають на незвіданий Острів Хранителів.')]),
  SeasonInfo(number: 15, title: 'Сезон 15: Кристалізовані', year: '2022', episodeCount: 30, episodes: [Episode(season: 'Сезон 15', number: 'Серія 1', title: 'Заклики Кристалів', duration: '11 хв', quality: '1080p • Дубляж', description: 'Оверлорд збирає Ради Рад у Кристальному Замку.')]),
];

List<Episode> episodesArchive = allSeasons.expand((s) => s.episodes).toList();

// -----------------------------------------------------------------------------
// MAIN CONTAINER
// -----------------------------------------------------------------------------
class MainContainer extends StatefulWidget {
  final ElementTheme currentElement;
  final Function(ElementTheme) onElementChanged;
  final int watchedCount;
  final String lastWatchedSeason;
  final String lastWatchedTitle;
  final Function(String, String) onEpisodeWatched;

  const MainContainer({
    super.key,
    required this.currentElement,
    required this.onElementChanged,
    required this.watchedCount,
    required this.lastWatchedSeason,
    required this.lastWatchedTitle,
    required this.onEpisodeWatched,
  });

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;
  final bool _isPremium = true;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).primaryColor;

    final List<Widget> screens = [
      HomeScreen(
        isPremium: _isPremium,
        watchedCount: widget.watchedCount,
        lastWatchedSeason: widget.lastWatchedSeason,
        lastWatchedTitle: widget.lastWatchedTitle,
        onWatch: widget.onEpisodeWatched,
      ),
      SeasonsCatalogScreen(onWatch: widget.onEpisodeWatched),
      const TimelineScreen(),
      const RadioScreen(),
      const BackpackScreen(),
      TeaShopSettingsScreen(
        currentElement: widget.currentElement,
        onElementChanged: widget.onElementChanged,
        isPremium: _isPremium,
        watchedCount: widget.watchedCount,
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF141419),
        selectedItemColor: activeColor,
        unselectedItemColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Головна'),
          BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: 'Архів'),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Хронологія'),
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Радіо'),
          BottomNavigationBarItem(icon: Icon(Icons.backpack), label: 'Рюкзак'),
          BottomNavigationBarItem(icon: Icon(Icons.coffee), label: 'Лавка'),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// VIDEO PLAYER SCREEN
// -----------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------
// 1. HOME SCREEN
// -----------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------
// 2. SEASONS CATALOG & DETAIL SCREEN
// -----------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------
// 3. TIMELINE SCREEN
// -----------------------------------------------------------------------------
class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Хронологія Всесвіту', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTimelineItem(context, 'Епоха 1: Початок (2011)', 'Пілотні серії • Пошук Золотої Зброї Спінжитсу'),
          _buildTimelineItem(context, 'Епоха 2: Класика (2011-2013)', 'Сезони 1–2 • Зростання Серпентинів та битва з Оверлордом'),
          _buildTimelineItem(context, 'Епоха 3: Техно (2014)', 'Сезон 3 • Перезавантаження та цифровий світ'),
          _buildTimelineItem(context, 'Епоха 4: Турнір (2015)', 'Сезон 4 • Турнір Стихій Майстра Чена'),
          _buildTimelineItem(context, 'Епоха 5: Привиди (2015)', 'Сезон 5 • Прокляте Королівство та Морро'),
          _buildTimelineItem(context, 'Епоха 6: Небесні Пірати (2016)', 'Сезон 6 • Джинн Надахан та команда підземелля'),
          _buildTimelineItem(context, 'Епоха 7: Руки Часу (2017)', 'Сезон 7 • Клинок Часу та Крук із Акроніксом'),
          _buildTimelineItem(context, 'Епоха 8: Воскресіння (2018)', 'Сезони 8–10 • Трилогія Они та Маски Обману'),
          _buildTimelineItem(context, 'Епоха 9: Нові Пригоди (2019-2022)', 'Сезони 11–15 • Від Асфіри до Кристального Замку'),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, String title, String subtitle) {
    final primaryColor = Theme.of(context).primaryColor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(radius: 8, backgroundColor: primaryColor),
            Container(width: 2, height: 60, color: primaryColor.withOpacity(0.3)),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: primaryColor)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 4. RADIO SCREEN
// -----------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------
// 5. BACKPACK SCREEN
// -----------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------
// 6. TEA SHOP & SETTINGS
// -----------------------------------------------------------------------------
class TeaShopSettingsScreen extends StatelessWidget {
  final ElementTheme currentElement;
  final Function(ElementTheme) onElementChanged;
  final bool isPremium;
  final int watchedCount;

  const TeaShopSettingsScreen({
    super.key,
    required this.currentElement,
    required this.onElementChanged,
    required this.isPremium,
    required this.watchedCount,
  });

  void _showTelegramDialog(BuildContext context, Color primaryColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B1B22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Зв'язок з Автором", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Напишіть мені в Telegram для отримання Премиум-ключа або підтримки проєкту:'),
            SizedBox(height: 12),
            SelectableText('@Veiqness', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Закрити', style: TextStyle(color: primaryColor))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    bool mechUnlocked = watchedCount >= 2;
    bool templeUnlocked = watchedCount >= 3;
    bool bountyUnlocked = watchedCount >= 5;
    bool raiderUnlocked = watchedCount >= 7;

    return Scaffold(
      appBar: AppBar(
        title: Text('Чайна Лавка Ву', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Вибір Стихії (Тема)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildElementChip(context, 'Енергія', ElementTheme.energy, const Color(0xFF76FF03)),
              _buildElementChip(context, 'Вогонь', ElementTheme.fire, const Color(0xFFFF3D00)),
              _buildElementChip(context, 'Лід', ElementTheme.ice, const Color(0xFF00E5FF)),
              _buildElementChip(context, 'Блискавка', ElementTheme.lightning, const Color(0xFF2979FF)),
              _buildElementChip(context, 'Земля', ElementTheme.earth, const Color(0xFFFF9100)),
              _buildElementChip(context, 'Вода', ElementTheme.water, const Color(0xFF00B0FF)),
              _buildElementChip(context, 'Тень Гармадона', ElementTheme.garmadon, const Color(0xFFD500F9)),
            ],
          ),
          const SizedBox(height: 24),
          Text('Вітрина Наборів (Прогрес: $watchedCount серій)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFF1B1B22), borderRadius: BorderRadius.circular(14), border: Border.all(color: primaryColor.withOpacity(0.2))),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildLegoBadge(context, 'Дракон', Icons.electric_bolt, true, 'Розблоковано'),
                  const SizedBox(width: 16),
                  _buildLegoBadge(context, 'Мех', Icons.local_fire_department, mechUnlocked, mechUnlocked ? 'Розблоковано' : 'Ще 2 перегляди'),
                  const SizedBox(width: 16),
                  _buildLegoBadge(context, 'Монастир', Icons.temple_buddhist, templeUnlocked, templeUnlocked ? 'Розблоковано' : 'Ще 3 перегляди'),
                  const SizedBox(width: 16),
                  _buildLegoBadge(context, 'Дарунок Долі', Icons.sailing, bountyUnlocked, bountyUnlocked ? 'Розблоковано' : 'Ще 5 переглядів'),
                  const SizedBox(width: 16),
                  _buildLegoBadge(context, 'Рейдер', Icons.directions_car, raiderUnlocked, raiderUnlocked ? 'Розблоковано' : 'Ще 7 переглядів'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
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
                const Text("Зв'язок з Автором & Ключі", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text('Потрібен Премиум-ключ або хочете підтримати проєкт? Пишіть автору в Telegram!', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('Telegram: @Veiqness', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () => _showTelegramDialog(context, primaryColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Зал Слави (Підтримка проєкту)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1B1B22), borderRadius: BorderRadius.circular(14), border: Border.all(color: primaryColor.withOpacity(0.2))),
            child: const Column(
              children: [
                ListTile(leading: Text('🥇', style: TextStyle(fontSize: 22)), title: Text('Перший Майстер Спінжитсу'), subtitle: Text('Топ-спонсори та меценати')),
                Divider(color: Colors.white10),
                ListTile(leading: Text('🥈', style: TextStyle(fontSize: 22)), title: Text('Провідні Ніндзя'), subtitle: Text('Власники Премиум-ключа')),
                Divider(color: Colors.white10),
                ListTile(leading: Text('🥉', style: TextStyle(fontSize: 22)), title: Text('Жителі Монастиря'), subtitle: Text('Друзі та активні фанати')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElementChip(BuildContext context, String label, ElementTheme theme, Color color) {
    final isSelected = currentElement == theme;
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      selected: isSelected,
      selectedColor: color,
      backgroundColor: const Color(0xFF1B1B22),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: isSelected ? color : Colors.white10)),
      onSelected: (_) => onElementChanged(theme),
    );
  }

  Widget _buildLegoBadge(BuildContext context, String name, IconData icon, bool unlocked, String subtitle) {
    final primaryColor = Theme.of(context).primaryColor;
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: unlocked ? primaryColor : Colors.grey.withOpacity(0.2),
          radius: 26,
          child: Icon(icon, color: unlocked ? Colors.black : Colors.grey, size: 28),
        ),
        const SizedBox(height: 6),
        Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: unlocked ? Colors.white : Colors.grey)),
        const SizedBox(height: 2),
        Text(subtitle, style: TextStyle(fontSize: 9, color: unlocked ? primaryColor : Colors.grey)),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// EPISODE CARD WIDGET
// -----------------------------------------------------------------------------
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
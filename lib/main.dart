import 'package:flutter/material.dart';

void main() {
  runApp(const NinjagoArchiveApp());
}

// -----------------------------------------------------------------------------
// STYLES & ELEMENTAL THEMES (Стихії)
// -----------------------------------------------------------------------------
enum ElementTheme { energy, fire, ice, lightning, earth, water }

class NinjagoArchiveApp extends StatefulWidget {
  const NinjagoArchiveApp({super.key});

  static _NinjagoArchiveAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_NinjagoArchiveAppState>()!;

  @override
  State<NinjagoArchiveApp> createState() => _NinjagoArchiveAppState();
}

class _NinjagoArchiveAppState extends State<NinjagoArchiveApp> {
  ElementTheme _currentElement = ElementTheme.energy;

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
        return const Color(0xFF00B0FF); // Ніва
      case ElementTheme.energy:
      default:
        return const Color(0xFF76FF03); // Ллойд
    }
  }

  void changeElement(ElementTheme element) {
    setState(() {
      _currentElement = element;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LEGO Ninjago Архів',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101014),
        primaryColor: primaryColor,
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          surface: const Color(0xFF1B1B22),
        ),
        fontFamily: 'Roboto',
      ),
      home: MainContainer(
        currentElement: _currentElement,
        onElementChanged: changeElement,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// MODELS (Моделі даних)
// -----------------------------------------------------------------------------
class Episode {
  final String season;
  final String number;
  final String title;
  final String duration;
  final String quality;
  final String description;
  bool isFavorite;

  Episode({
    required this.season,
    required this.number,
    required this.title,
    required this.duration,
    required this.quality,
    required this.description,
    this.isFavorite = false,
  });
}

class SenseiQuote {
  final String quote;
  final String source;
  SenseiQuote({required this.quote, required this.source});
}

// -----------------------------------------------------------------------------
// MOCK DATA (Дані архіву)
// -----------------------------------------------------------------------------
final List<SenseiQuote> wuQuotes = [
  SenseiQuote(quote: "Ніколи не відкладай на завтра те, що можна зробити сьогодні.", source: "Сенсей Ву"),
  SenseiQuote(quote: "Найкращий спосіб перемогти ворога — зробити його своїм другом.", source: "Сенсей Ву"),
  SenseiQuote(quote: "Ніндзя ніколи не здаються!", source: "Сенсей Ву"),
];

List<Episode> episodesArchive = [
  Episode(
    season: 'Пілотний сезон',
    number: 'Серія 1',
    title: 'Шлях Ніндзя',
    duration: '22 хв',
    quality: '1080p • Дубляж',
    description: 'Коваля Кая відвідує загадковий старий ремісник Ву, який пропонує йому стати ніндзя...',
    isFavorite: true,
  ),
  Episode(
    season: 'Пілотний сезон',
    number: 'Серія 2',
    title: 'Зброя Зі Сходу',
    duration: '22 хв',
    quality: '1080p • Дубляж',
    description: 'Команда вирушає на пошуки Золотої Зброї Спінжитсу.',
  ),
  Episode(
    season: 'Сезон 1',
    number: 'Серія 1',
    title: 'Воскресіння Змій',
    duration: '21 хв',
    quality: '1080p • Дубляж',
    description: 'Ллойд Гармадон випадково випускає давнє племя Зміїних Кланів.',
    isFavorite: true,
  ),
];

// -----------------------------------------------------------------------------
// MAIN NAVIGATION (Головний контейнер)
// -----------------------------------------------------------------------------
class MainContainer extends StatefulWidget {
  final ElementTheme currentElement;
  final Function(ElementTheme) onElementChanged;

  const MainContainer({
    super.key,
    required this.currentElement,
    required this.onElementChanged,
  });

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _currentIndex = 0;
  int _dailyWatchLimit = 3;
  bool _isPremium = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).primaryColor;

    final List<Widget> screens = [
      HomeScreen(isPremium: _isPremium, dailyLimit: _dailyWatchLimit),
      const SeasonsCatalogScreen(),
      const TimelineScreen(),
      const OpeningsAudioScreen(),
      TeaShopSettingsScreen(
        currentElement: widget.currentElement,
        onElementChanged: widget.onElementChanged,
        isPremium: _isPremium,
        onActivatePremium: () {
          setState(() => _isPremium = true);
        },
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
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Головна'),
          BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: 'Архів'),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Хронологія'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Опенинги'),
          BottomNavigationBarItem(icon: Icon(Icons.coffee), label: 'Лавка Ву'),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 1. HOME SCREEN (Головна)
// -----------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  final bool isPremium;
  final int dailyLimit;

  const HomeScreen({super.key, required this.isPremium, required this.dailyLimit});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final randomQuote = wuQuotes[0];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NINJAGO: Спінжитсу Архів',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.send_rounded),
            tooltip: 'Telegram Спільнота',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Перехід у Telegram-канал проекту...')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Свиток Ву
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF252530),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.menu_book_rounded, color: primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Text('Мудрість Сенсея Ву', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('"${randomQuote.quote}"', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 14)),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Лимит просмотров
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B22),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isPremium ? 'Статус: Премиум Ключ Активовано ⚡' : 'Безкоштовний суточний ліміт: $dailyLimit/5',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                if (!isPremium)
                  TextButton(
                    onPressed: () {},
                    child: Text('Безліміт', style: TextStyle(color: primaryColor)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Блок продолжения просмотра
          const Text('Продовжити перегляд', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B22),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Пілотний сезон • Серія 1', style: TextStyle(color: primaryColor, fontSize: 13)),
                const SizedBox(height: 4),
                const Text('Шлях Ніндзя', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Таймкод: 12:45 / 22:00', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Icon(Icons.play_circle_fill, color: primaryColor, size: 36),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Раздел избравшего
          const Text('Останні серії', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...episodesArchive.map((ep) => EpisodeCard(episode: ep)),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. SEASONS & ARCHIVE CATALOG (Всі 15 Сезонів + Спешли)
// -----------------------------------------------------------------------------
class SeasonsCatalogScreen extends StatelessWidget {
  const SeasonsCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Архів Контенту', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            indicatorColor: primaryColor,
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: 'Класичні Сезони (0-15)'),
              Tab(text: 'Спецвипуски & Фільми'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Таб 1: Сезоны 0-15
            ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 16,
              itemBuilder: (context, index) {
                final title = index == 0 ? 'Пілотний сезон (2011)' : 'Сезон $index';
                return Card(
                  color: const Color(0xFF1B1B22),
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('1080p • Повний український дубляж', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: primaryColor),
                  ),
                );
              },
            ),
            // Таб 2: Спешлы
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSpecialCard(context, 'День День Відпочинку (Day of the Departed)', '44 хв • 2016'),
                _buildSpecialCard(context, 'LEGO Ninjago: Фільм (The Movie)', '1 год 41 хв • 2017'),
                _buildSpecialCard(context, 'Острів (The Island)', '4 серії • 2021'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialCard(BuildContext context, String title, String info) {
    final primaryColor = Theme.of(context).primaryColor;
    return Card(
      color: const Color(0xFF1B1B22),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(Icons.star, color: primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(info, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. TIMELINE SCREEN (Інтерактивний Таймлайн)
// -----------------------------------------------------------------------------
class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Хронологія Подій', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTimelineNode(context, '1. Початок', 'Пілотні серії (Пошук Золотої Зброї)', true),
          _buildTimelineNode(context, '2. Класика', 'Сезони 1–2 (Розквіт Серпентинів та Оверлорд)', false),
          _buildTimelineNode(context, '3. Технологічна Ера', 'Сезон 3: Перезавантаження', false),
          _buildTimelineNode(context, '4. Турнір Стихій', 'Сезон 4: Змагання Майстра Чена', false),
          _buildTimelineNode(context, '5. Одержимість', 'Сезон 5: Морро та Привиди', false),
        ],
      ),
    );
  }

  Widget _buildTimelineNode(BuildContext context, String title, String desc, bool isFirst) {
    final primaryColor = Theme.of(context).primaryColor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(radius: 8, backgroundColor: primaryColor),
            Container(width: 2, height: 50, color: Colors.white10),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 20),
            ],
          ),
        )
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// 4. OPENINGS AUDIO PLAYER (Аудіоплеер Опенингів)
// -----------------------------------------------------------------------------
class OpeningsAudioScreen extends StatelessWidget {
  const OpeningsAudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final tracks = [
      'The Weekend Whip (Original Pilot)',
      'The Pirate Whip (Season 6)',
      'The Rift Whip (Day of the Departed)',
      'The Wicked Whip (Season 8)',
      'The Ghost Whip (Season 5)',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Радіо Монастиря: Опенинги', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tracks.length,
        itemBuilder: (context, index) {
          return Card(
            color: const Color(0xFF1B1B22),
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: Icon(Icons.music_note_rounded, color: primaryColor),
              title: Text(tracks[index], style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: const Text('The Fold • MP3 320kbps', style: TextStyle(color: Colors.grey, fontSize: 12)),
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow_rounded),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 5. TEA SHOP & SETTINGS (Чайна лавка Ву / Зал Слави / Стихії)
// -----------------------------------------------------------------------------
class TeaShopSettingsScreen extends StatelessWidget {
  final ElementTheme currentElement;
  final Function(ElementTheme) onElementChanged;
  final bool isPremium;
  final VoidCallback onActivatePremium;

  const TeaShopSettingsScreen({
    super.key,
    required this.currentElement,
    required this.onElementChanged,
    required this.isPremium,
    required this.onActivatePremium,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text('Чайна Лавка Сенсея Ву', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Раздел стихии
          const Text('Вибір Сили Стихії (Тема)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              _buildElementChip(context, 'Енергія (Ллойд)', ElementTheme.energy, const Color(0xFF76FF03)),
              _buildElementChip(context, 'Вогонь (Кай)', ElementTheme.fire, const Color(0xFFFF3D00)),
              _buildElementChip(context, 'Лід (Зейн)', ElementTheme.ice, const Color(0xFF00E5FF)),
              _buildElementChip(context, 'Блискавка (Джей)', ElementTheme.lightning, const Color(0xFF2979FF)),
              _buildElementChip(context, 'Земля (Коул)', ElementTheme.earth, const Color(0xFFFF9100)),
              _buildElementChip(context, 'Вода (Нія)', ElementTheme.water, const Color(0xFF00B0FF)),
            ],
          ),
          const SizedBox(height: 24),

          // Зал славы
          const Text('Зал Слави (Поддержка)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1B1B22), borderRadius: BorderRadius.circular(10)),
            child: const Column(

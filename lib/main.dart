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

  @override
  State<NinjagoArchiveApp> createState() => _NinjagoArchiveAppState();
}

class _NinjagoArchiveAppState extends State<NinjagoArchiveApp> {
  ElementTheme _currentElement = ElementTheme.energy;
  int _watchedCount = 1;

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
      case ElementTheme.energy:
      default:
        return const Color(0xFF76FF03); // Ллойд
    }
  }

  void changeElement(ElementTheme element) {
    setState(() => _currentElement = element);
  }

  void incrementWatched() {
    setState(() {
      _watchedCount++;
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
        watchedCount: _watchedCount,
        onEpisodeWatched: incrementWatched,
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// MODELS
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

class SenseiQuote {
  final String quote;
  final String author;
  SenseiQuote({required this.quote, required this.author});
}

// Список мудростей Сенсея Ву
final List<SenseiQuote> senseiQuotes = [
  SenseiQuote(quote: "Ніколи не відкладай на завтра те, що можна зробити сьогодні.", author: "Сенсей Ву"),
  SenseiQuote(quote: "Шлях до справжньої сили лежить через дисципліну та серце ніндзя.", author: "Сенсей Ву"),
  SenseiQuote(quote: "Учень вчить вчителя. Навіть найменший може змінити все.", author: "Сенсей Ву"),
  SenseiQuote(quote: "Ніндзя ніколи не здаються, коли вірять у своїх друзів.", author: "Сенсей Ву"),
];

List<Episode> episodesArchive = [
  Episode(
    season: 'Пілотний сезон',
    number: 'Серія 1',
    title: 'Шлях Ніндзя',
    duration: '22 хв',
    quality: '1080p • Дубляж',
    description: 'Коваля Кая відвідує загадковий старий ремісник Ву...',
    isFavorite: true,
    isDownloaded: true,
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
// MAIN CONTAINER
// -----------------------------------------------------------------------------
class MainContainer extends StatefulWidget {
  final ElementTheme currentElement;
  final Function(ElementTheme) onElementChanged;
  final int watchedCount;
  final VoidCallback onEpisodeWatched;

  const MainContainer({
    super.key,
    required this.currentElement,
    required this.onElementChanged,
    required this.watchedCount,
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
        onWatch: widget.onEpisodeWatched,
      ),
      const SeasonsCatalogScreen(),
      const TimelineScreen(),
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
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Головна'),
          BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: 'Архів'),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Хронологія'),
          BottomNavigationBarItem(icon: Icon(Icons.backpack), label: 'Рюкзак'),
          BottomNavigationBarItem(icon: Icon(Icons.coffee), label: 'Лавка Ву'),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 1. HOME SCREEN (З цитатою Сенсея Ву)
// -----------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  final bool isPremium;
  final int watchedCount;
  final VoidCallback onWatch;

  const HomeScreen({
    super.key,
    required this.isPremium,
    required this.watchedCount,
    required this.onWatch,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    // Беремо першу мудрість для демонстрації
    final quote = senseiQuotes[0];

    return Scaffold(
      appBar: AppBar(
        title: Text('NINJAGO: Архів', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Свиток мудрості Сенсея Ву
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B22),
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
                    Text('Свиток Мудрості Сенсея Ву', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('"${quote.quote}"', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13, color: Colors.white70)),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('— ${quote.author}', style: TextStyle(color: primaryColor, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Статус Премиума
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B22),
              borderRadius: BorderRadius.circular(12),
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
          const SizedBox(height: 20),
          const Text('Останні поступлення', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...episodesArchive.map((ep) => EpisodeCard(episode: ep, onPlayPressed: onWatch)),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. SEASONS CATALOG
// -----------------------------------------------------------------------------
class SeasonsCatalogScreen extends StatelessWidget {
  const SeasonsCatalogScreen({super.key});

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
        itemCount: 16,
        itemBuilder: (context, index) {
          final title = index == 0 ? 'Пілотний сезон (2011)' : 'Сезон $index';
          return Card(
            color: const Color(0xFF1B1B22),
            margin: const EdgeInsets.only(bottom: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('1080p • Український дубляж', style: TextStyle(color: Colors.grey, fontSize: 12)),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: primaryColor),
            ),
          );
        },
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
          _buildTimelineItem(context, 'Епоха 1: Початок', 'Пілотні серії • Пошук Золотої Зброї Спінжитсу', true),
          _buildTimelineItem(context, 'Епоха 2: Класика', 'Сезони 1–2 • Зростання Серпентинів та битва з Оверлордом', false),
          _buildTimelineItem(context, 'Епоха 3: Техно', 'Сезон 3 • Перезавантаження та цифровий світ', false),
          _buildTimelineItem(context, 'Епоха 4: Турнір', 'Сезон 4 • Турнір Стихій Майстра Чена', false),
          _buildTimelineItem(context, 'Епоха 5: Привиди', 'Сезон 5 • Прокляте Королівство та Морро', false),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, String title, String subtitle, bool isFirst) {
    final primaryColor = Theme.of(context).primaryColor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(radius: 8, backgroundColor: primaryColor),
            Container(width: 2, height: 60, color: Colors.white10),
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
// 4. BACKPACK SCREEN
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
// 5. TEA SHOP & SETTINGS (З кнопкою зв'язку @Veiqness та Залом Слави)
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

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    bool mechUnlocked = watchedCount >= 2;
    bool templeUnlocked = watchedCount >= 3;

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
            children: [
              _buildElementChip(context, 'Енергія', ElementTheme.energy, const Color(0xFF76FF03)),
              _buildElementChip(context, 'Вогонь', ElementTheme.fire, const Color(0xFFFF3D00)),
              _buildElementChip(context, 'Лід', ElementTheme.ice, const Color(0xFF00E5FF)),
              _buildElementChip(context, 'Блискавка', ElementTheme.lightning, const Color(0xFF2979FF)),
              _buildElementChip(context, 'Земля', ElementTheme.earth, const Color(0xFFFF9100)),
              _buildElementChip(context, 'Вода', ElementTheme.water, const Color(0xFF00B0FF)),
            ],
          ),
          const SizedBox(height: 24),
          Text('Вітрина Наборів (Прогрес: $watchedCount серій)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFF1B1B22), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegoBadge('Дракон', Icons.electric_bolt, true, 'Розблоковано'),
                _buildLegoBadge('Мех', Icons.local_fire_department, mechUnlocked, mechUnlocked ? 'Розблоковано' : 'Ще 2 перегляди'),
                _buildLegoBadge('Монастир', Icons.temple_buddhist, templeUnlocked, templeUnlocked ? 'Розблоковано' : 'Ще 3 перегляди'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // КНОПКА ЗВ'ЯЗКУ З АВТОРОМ (@Veiqness)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B22),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Зв\'язок з Автором & Ключі', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text('Потрібен Премиум-ключ або хочете підтримати проєкт? Пишіть автору в Telegram!', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: const Icon(Icons.send_rounded),
                    label: const Text('Telegram: @Veiqness', style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Контакт автора: @Veiqness (Telegram)')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ЗАЛ СЛАВИ (HALL OF FAME)
          const Text('Зал Слави (Підтримка проєкту)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF1B1B22), borderRadius: BorderRadius.circular(12)),
            child: const Column(
              children: [
                ListTile(
                  leading: Text('🥇', style: TextStyle(fontSize: 22)),
                  title: Text('Перший Майстер Спінжитсу'),
                  subtitle: Text('Топ-спонсори та меценати'),
                ),
                Divider(color: Colors.white10),
                ListTile(
                  leading: Text('🥈', style: TextStyle(fontSize: 22)),
                  title: Text('Провідні Ніндзя'),
                  subtitle: Text('Власники Премиум-ключа'),
                ),
                Divider(color: Colors.white10),
                ListTile(
                  leading: Text('🥉', style: TextStyle(fontSize: 22)),
                  title: Text('Жителі Монастиря'),
                  subtitle: Text('Друзі та активні фанати'),
                ),
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
      label: Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white)),
      selected: isSelected,
      selectedColor: color,
      backgroundColor: const Color(0xFF1B1B22),
      onSelected: (_) => onElementChanged(theme),
    );
  }

  Widget _buildLegoBadge(String name, IconData icon, bool unlocked, String subtitle) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: unlocked ? Colors.amber : Colors.grey.withOpacity(0.2),
          radius: 26,
          child: Icon(icon, color: unlocked ? Colors.black : Colors.grey, size: 28),
        ),
        const SizedBox(height: 6),
        Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: unlocked ? Colors.white : Colors.grey)),
        const SizedBox(height: 2),
        Text(subtitle, style: TextStyle(fontSize: 9, color: unlocked ? Colors.amber : Colors.grey)),
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
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      color: const Color(0xFF1B1B22),
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: primaryColor,
          child: IconButton(
            icon: const Icon(Icons.play_arrow_rounded, color: Colors.black),
            onPressed: () {
              if (onPlayPressed != null) onPlayPressed!();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Відтворення: ${episode.title} (+1 до прогресу наборів!)'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
        title: Text('${episode.number}: ${episode.title}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${episode.duration} • ${episode.quality}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(episode.isDownloaded ? Icons.download_done : Icons.download_outlined, color: Colors.grey, size: 20),
            const SizedBox(width: 8),
            Icon(episode.isFavorite ? Icons.bookmark : Icons.bookmark_border, color: primaryColor),
          ],
        ),
      ),
    );
  }
}
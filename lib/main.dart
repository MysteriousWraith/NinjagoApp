import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NinjagoArchiveApp());
}

class NinjagoArchiveApp extends StatefulWidget {
  const NinjagoArchiveApp({super.key});

  @override
  State<NinjagoArchiveApp> createState() => _NinjagoArchiveAppState();
}

class _NinjagoArchiveAppState extends State<NinjagoArchiveApp> {
  String _currentTheme = 'Вогонь';
  int _watchedCount = 3;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentTheme = prefs.getString('current_theme') ?? 'Вогонь';
      _watchedCount = prefs.getInt('watched_count') ?? 3;
    });
  }

  Future<void> _setTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_theme', theme);
    setState(() {
      _currentTheme = theme;
    });
  }

  Color getThemeColor() {
    switch (_currentTheme) {
      case 'Вогонь':
        return Colors.deepOrange;
      case 'Енергія':
        return Colors.greenAccent;
      case 'Лід':
        return Colors.cyan;
      case 'Блискавка':
        return Colors.amber;
      case 'Земля':
        return Colors.brown;
      case 'Вода':
        return Colors.blue;
      case 'Тень Гармадона':
        return Colors.purpleAccent;
      default:
        return Colors.deepOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Чайна Лавка Ву',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: getThemeColor(),
        colorScheme: ColorScheme.dark(
          primary: getThemeColor(),
          surface: const Color(0xFF1E1E1E),
        ),
      ),
      home: MainHomeScreen(
        currentTheme: _currentTheme,
        onThemeChanged: _setTheme,
        themeColor: getThemeColor(),
        watchedCount: _watchedCount,
      ),
    );
  }
}

class MainHomeScreen extends StatefulWidget {
  final String currentTheme;
  final ValueChanged<String> onThemeChanged;
  final Color themeColor;
  final int watchedCount;

  const MainHomeScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
    required this.themeColor,
    required this.watchedCount,
  });

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _currentIndex = 5; // Лавка за замовчуванням

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildPlaceholder('Головна'),
      const ArchiveScreen(),
      _buildPlaceholder('Хронологія'),
      _buildPlaceholder('Радіо'),
      _buildPlaceholder('Рюкзак'),
      ShopScreen(
        currentTheme: widget.currentTheme,
        onThemeChanged: widget.onThemeChanged,
        themeColor: widget.themeColor,
        watchedCount: widget.watchedCount,
      ),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF181818),
        selectedItemColor: widget.themeColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Головна'),
          BottomNavigationBarItem(icon: Icon(Icons.video_library), label: 'Архів'),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Хронол...'),
          BottomNavigationBarItem(icon: Icon(Icons.radio), label: 'Радіо'),
          BottomNavigationBarItem(icon: Icon(Icons.backpack), label: 'Рюкзак'),
          BottomNavigationBarItem(icon: Icon(Icons.local_cafe), label: 'Лавка'),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(fontSize: 24, color: widget.themeColor),
      ),
    );
  }
}

class ShopScreen extends StatelessWidget {
  final String currentTheme;
  final ValueChanged<String> onThemeChanged;
  final Color themeColor;
  final int watchedCount;

  const ShopScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
    required this.themeColor,
    required this.watchedCount,
  });

  @override
  Widget build(BuildContext context) {
    final themes = ['Енергія', 'Вогонь', 'Лід', 'Блискавка', 'Земля', 'Вода', 'Тень Гармадона'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Чайна Лавка Ву', style: TextStyle(color: themeColor)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Вибір Стихії (Тема)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: themes.map((theme) {
              final isSelected = currentTheme == theme;
              return ChoiceChip(
                label: Text(theme),
                selected: isSelected,
                selectedColor: themeColor,
                onSelected: (selected) {
                  if (selected) onThemeChanged(theme);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text('Вітрина Наборів (Прогрес: $watchedCount серій)', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSetItem('Дракон', Icons.flash_on, true),
              _buildSetItem('Мех', Icons.whatshot, true),
              _buildSetItem('Монастир', Icons.temple_buddhist, true),
              _buildSetItem('Дарунок Долі', Icons.sailing, false),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: themeColor.withOpacity(0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Зв\'язок з Автором & Ключі', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Text('Потрібен Преміум-ключ або хочете підтримати проєкт?\nПишіть автору в Telegram!', style: TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                  label: const Text('Telegram: @Veiqness', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Зал Слави (Підтримка проєкту)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildHallItem(Icons.military_tech, 'Перший Майстер Спінжитсу', 'Топ-спонсори та меценати'),
          _buildHallItem(Icons.shield, 'Провідні Ніндзя', 'Власники Преміум-ключа'),
        ],
      ),
    );
  }

  Widget _buildSetItem(String title, IconData icon, bool unlocked) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: unlocked ? themeColor.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: unlocked ? themeColor : Colors.grey),
          ),
          child: Icon(icon, color: unlocked ? themeColor : Colors.grey, size: 28),
        ),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        Text(unlocked ? 'Розблоковано' : 'Закрито', style: TextStyle(fontSize: 10, color: unlocked ? themeColor : Colors.grey)),
      ],
    );
  }

  Widget _buildHallItem(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 30),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Архів Сезонів (0–15)')),
      body: ListView.builder(
        itemCount: 16,
        itemBuilder: (context, index) {
          return Card(
            color: const Color(0xFF1E1E1E),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              title: Text('Сезон $index: Назва сезону', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('1080p • Дубляж', style: TextStyle(color: Colors.grey, fontSize: 12)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}

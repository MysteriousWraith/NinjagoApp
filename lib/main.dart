import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/ninjago_data.dart';
import 'screens/home_screen.dart';
import 'screens/archive_screen.dart';
import 'screens/timeline_screen.dart';
import 'screens/radio_screen.dart';
import 'screens/backpack_screen.dart';
import 'screens/shop_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final activeColor = getElementColor(_currentElement);

    if (_isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: activeColor),
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
        primaryColor: activeColor,
        colorScheme: ColorScheme.dark(
          primary: activeColor,
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

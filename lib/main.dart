import 'package:flutter/material.dart';
import '../models/ninjago_data.dart';
import 'video_player_screen.dart';
import 'widgets.dart';

class SeasonsCatalogScreen extends StatefulWidget {
  final Function(String, String) onWatch;
  final Function(Episode) onToggleFavorite;

  const SeasonsCatalogScreen({
    super.key, 
    required this.onWatch,
    required this.onToggleFavorite,
  });

  @override
  State<SeasonsCatalogScreen> createState() => _SeasonsCatalogScreenState();
}

class _SeasonsCatalogScreenState extends State<SeasonsCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    List> matchingEpisodes = [];
    if (_searchQuery.isNotEmpty) {
      for (var season in allSeasons) {
        for (var ep in season.episodes) {
          final titleMatch = ep.title.toLowerCase().contains(_searchQuery);
          final numMatch = ep.number.toString().contains(_searchQuery);
          if (titleMatch || numMatch) {
            matchingEpisodes.add({'season': season, 'episode': ep});
          }
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Архів Сезонів (0–15)', style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Пошук серії за назвою або номером...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
                prefixIcon: Icon(Icons.search, color: primaryColor),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF1B1B22),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: primaryColor.withOpacity(0.15)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: primaryColor.withOpacity(0.15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchQuery.isNotEmpty
                ? (matchingEpisodes.isEmpty
                    ? Center(
                        child: Text(
                          'Нічого не знайдено 🥷',
                          style: TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: matchingEpisodes.length,
                        itemBuilder: (context, index) {
                          final item = matchingEpisodes[index];
                          final SeasonInfo season = item['season'];
                          final Episode ep = item['episode'];
                          return EpisodeCard(
                            episode: ep,
                            onPlayPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoPlayerScreen(
                                    episode: ep,
                                    onWatch: widget.onWatch,
                                  ),
                                ),
                              );
                            },
                            onFavoritePressed: () {
                              setState(() {
                                widget.onToggleFavorite(ep);
                              });
                            },
                          );
                        },
                      ))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: allSeasons.length,
                    itemBuilder: (context, index) {
                      final s = allSeasons[index];
                      return Card(
                        color: const Color(0xFF1B1B22),
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: primaryColor.withOpacity(0.15)),
                        ),
                        child: ListTile(
                          title: Text(s.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          subtitle: Text('${s.year} • ${s.episodeCount} серій • 1080p Дубляж', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: primaryColor),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SeasonDetailScreen(
                                  season: s, 
                                  onWatch: widget.onWatch,
                                  onToggleFavorite: widget.onToggleFavorite,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class SeasonDetailScreen extends StatefulWidget {
  final SeasonInfo season;
  final Function(String, String) onWatch;
  final Function(Episode) onToggleFavorite;

  const SeasonDetailScreen({
    super.key, 
    required this.season, 
    required this.onWatch,
    required this.onToggleFavorite,
  });

  @override
  State<SeasonDetailScreen> createState() => _SeasonDetailScreenState();
}

class _SeasonDetailScreenState extends State<SeasonDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final filteredEpisodes = widget.season.episodes.where((ep) {
      final titleMatch = ep.title.toLowerCase().contains(_searchQuery);
      final numMatch = ep.number.toString().contains(_searchQuery);
      return titleMatch || numMatch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.season.title, style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Пошук серії у сезоні...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14),
                prefixIcon: Icon(Icons.search, color: primaryColor),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFF1B1B22),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: primaryColor.withOpacity(0.15)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: primaryColor.withOpacity(0.15)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredEpisodes.isEmpty
                ? Center(
                    child: Text(
                      'Серій не знайдено',
                      style: TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 16),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      Text('Серії сезону (${filteredEpisodes.length})', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor)),
                      const SizedBox(height: 12),
                      ...filteredEpisodes.map((ep) => EpisodeCard(
                        episode: ep,
                        onPlayPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(episode: ep, onWatch: widget.onWatch)));
                        },
                        onFavoritePressed: () {
                          setState(() {
                            widget.onToggleFavorite(ep);
                          });
                        },
                      )),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

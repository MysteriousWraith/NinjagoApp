import 'package:flutter/material.dart';

enum ElementTheme { energy, fire, ice, lightning, earth, water, garmadon }

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

Color getElementColor(ElementTheme element) {
  switch (element) {
    case ElementTheme.fire:
      return const Color(0xFFFF3D00);
    case ElementTheme.ice:
      return const Color(0xFF00E5FF);
    case ElementTheme.lightning:
      return const Color(0xFF2979FF);
    case ElementTheme.earth:
      return const Color(0xFFFF9100);
    case ElementTheme.water:
      return const Color(0xFF00B0FF);
    case ElementTheme.garmadon:
      return const Color(0xFFD500F9);
    case ElementTheme.energy:
    default:
      return const Color(0xFF76FF03);
  }
}

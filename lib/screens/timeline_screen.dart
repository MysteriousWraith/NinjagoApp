import 'package:flutter/material.dart';

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

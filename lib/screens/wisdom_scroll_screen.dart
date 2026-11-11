import 'package:flutter/material.dart';
import 'dart:math';

class WisdomScrollScreen extends StatelessWidget {
  const WisdomScrollScreen({super.key});

  // Коллекция мудростей Сенсея Ву на украинском
  static const List<String> _wuWisdoms = [
    "Шлях до вершини довгий, але кожен крок робить тебе сильнішим.",
    "Учень, який запитує, шукає знань. Учень, який мовчить, ховає свої помилки.",
    "Чай смакує краще, коли заварюється у спокої.",
    "Навіть найпотужніша буря починається з легкого вітерця.",
    "Щоб зупинити ворога всередині себе, спершу зрозумій його.",
    "Пам'ятай: ніндзя ніколи не здається!",
  ];

  @override
  Widget build(BuildContext context) {
    final randomWisdom = _wuWisdoms[Random().nextInt(_wuWisdoms.length)];
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFF131318),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Свиток Мудрості',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Иконка свитка / чашки чая
              Icon(
                Icons.auto_stories_rounded,
                size: 80,
                color: primaryColor,
              ),
              const SizedBox(height: 24),
              
              // Заголовок
              const Text(
                'Ліміт переглядів вичерпано!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Карточка со свитком мудрости
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1B22),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Мудрість Сенсея Ву:',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '"$randomWisdom"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Кнопка получения Премиум-ключа (переход в телеграм)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.telegram),
                label: const Text(
                  'Отримати Премиум-ключ в Telegram',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                onPressed: () {
                  // Здесь позже укажем твою ссылку на Telegram
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

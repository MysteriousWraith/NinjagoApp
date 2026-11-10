import 'package:flutter/material.dart';
import '../models/ninjago_data.dart';

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

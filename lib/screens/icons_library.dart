import 'package:flutter/material.dart';

class IconItem {
  final String name;
  final IconData icon;
  final String category;
  IconItem({required this.name, required this.icon, required this.category});
}

class IconsLibrary extends StatefulWidget {
  final Function(IconData) onIconSelected;
  const IconsLibrary({super.key, required this.onIconSelected});

  @override
  State<IconsLibrary> createState() => _IconsLibraryState();
}

class _IconsLibraryState extends State<IconsLibrary> {
  String _selectedCategory = 'الكل';
  final List<String> _categories = [
    'الكل', 'أساسية', 'اتجاهات', 'اتصالات', 'وسائط', 'مستندات',
    'طقس', 'رياضة', 'طعام', 'سفر', 'رموز', 'وجوه',
  ];

  late List<IconItem> _allIcons;
  late List<IconItem> _filteredIcons;

  @override
  void initState() {
    super.initState();
    _allIcons = _generateIcons();
    _filteredIcons = _allIcons;
  }

  List<IconItem> _generateIcons() {
    return [
      // أساسية
      IconItem(name: 'home', icon: Icons.home, category: 'أساسية'),
      IconItem(name: 'search', icon: Icons.search, category: 'أساسية'),
      IconItem(name: 'settings', icon: Icons.settings, category: 'أساسية'),
      IconItem(name: 'favorite', icon: Icons.favorite, category: 'أساسية'),
      IconItem(name: 'star', icon: Icons.star, category: 'أساسية'),
      IconItem(name: 'check', icon: Icons.check, category: 'أساسية'),
      IconItem(name: 'close', icon: Icons.close, category: 'أساسية'),
      IconItem(name: 'add', icon: Icons.add, category: 'أساسية'),
      IconItem(name: 'remove', icon: Icons.remove, category: 'أساسية'),
      IconItem(name: 'more', icon: Icons.more_horiz, category: 'أساسية'),
      IconItem(name: 'menu', icon: Icons.menu, category: 'أساسية'),
      IconItem(name: 'info', icon: Icons.info, category: 'أساسية'),

      // اتجاهات
      IconItem(name: 'arrow_up', icon: Icons.arrow_upward, category: 'اتجاهات'),
      IconItem(name: 'arrow_down', icon: Icons.arrow_downward, category: 'اتجاهات'),
      IconItem(name: 'arrow_left', icon: Icons.arrow_back, category: 'اتجاهات'),
      IconItem(name: 'arrow_right', icon: Icons.arrow_forward, category: 'اتجاهات'),
      IconItem(name: 'chevron_up', icon: Icons.keyboard_arrow_up, category: 'اتجاهات'),
      IconItem(name: 'chevron_down', icon: Icons.keyboard_arrow_down, category: 'اتجاهات'),
      IconItem(name: 'chevron_left', icon: Icons.keyboard_arrow_left, category: 'اتجاهات'),
      IconItem(name: 'chevron_right', icon: Icons.keyboard_arrow_right, category: 'اتجاهات'),

      // اتصالات
      IconItem(name: 'phone', icon: Icons.phone, category: 'اتصالات'),
      IconItem(name: 'email', icon: Icons.email, category: 'اتصالات'),
      IconItem(name: 'message', icon: Icons.message, category: 'اتصالات'),
      IconItem(name: 'call', icon: Icons.call, category: 'اتصالات'),
      IconItem(name: 'wifi', icon: Icons.wifi, category: 'اتصالات'),
      IconItem(name: 'bluetooth', icon: Icons.bluetooth, category: 'اتصالات'),

      // وسائط
      IconItem(name: 'play', icon: Icons.play_arrow, category: 'وسائط'),
      IconItem(name: 'pause', icon: Icons.pause, category: 'وسائط'),
      IconItem(name: 'stop', icon: Icons.stop, category: 'وسائط'),
      IconItem(name: 'camera', icon: Icons.camera_alt, category: 'وسائط'),
      IconItem(name: 'image', icon: Icons.image, category: 'وسائط'),
      IconItem(name: 'video', icon: Icons.videocam, category: 'وسائط'),
      IconItem(name: 'music', icon: Icons.music_note, category: 'وسائط'),
      IconItem(name: 'mic', icon: Icons.mic, category: 'وسائط'),

      // مستندات
      IconItem(name: 'file', icon: Icons.insert_drive_file, category: 'مستندات'),
      IconItem(name: 'folder', icon: Icons.folder, category: 'مستندات'),
      IconItem(name: 'save', icon: Icons.save, category: 'مستندات'),
      IconItem(name: 'print', icon: Icons.print, category: 'مستندات'),
      IconItem(name: 'edit', icon: Icons.edit, category: 'مستندات'),
      IconItem(name: 'delete', icon: Icons.delete, category: 'مستندات'),

      // طقس
      IconItem(name: 'sun', icon: Icons.wb_sunny, category: 'طقس'),
      IconItem(name: 'cloud', icon: Icons.cloud, category: 'طقس'),
      IconItem(name: 'rain', icon: Icons.grain, category: 'طقس'),
      IconItem(name: 'snow', icon: Icons.ac_unit, category: 'طقس'),
      IconItem(name: 'storm', icon: Icons.flash_on, category: 'طقس'),

      // رياضة
      IconItem(name: 'sports', icon: Icons.sports_soccer, category: 'رياضة'),
      IconItem(name: 'basketball', icon: Icons.sports_basketball, category: 'رياضة'),
      IconItem(name: 'football', icon: Icons.sports_football, category: 'رياضة'),
      IconItem(name: 'tennis', icon: Icons.sports_tennis, category: 'رياضة'),
      IconItem(name: 'fitness', icon: Icons.fitness_center, category: 'رياضة'),

      // طعام
      IconItem(name: 'restaurant', icon: Icons.restaurant, category: 'طعام'),
      IconItem(name: 'coffee', icon: Icons.coffee, category: 'طعام'),
      IconItem(name: 'pizza', icon: Icons.local_pizza, category: 'طعام'),
      IconItem(name: 'cake', icon: Icons.cake, category: 'طعام'),
      IconItem(name: 'icecream', icon: Icons.icecream, category: 'طعام'),

      // سفر
      IconItem(name: 'flight', icon: Icons.flight, category: 'سفر'),
      IconItem(name: 'car', icon: Icons.directions_car, category: 'سفر'),
      IconItem(name: 'train', icon: Icons.train, category: 'سفر'),
      IconItem(name: 'bus', icon: Icons.directions_bus, category: 'سفر'),
      IconItem(name: 'bike', icon: Icons.directions_bike, category: 'سفر'),
      IconItem(name: 'walk', icon: Icons.directions_walk, category: 'سفر'),

      // رموز
      IconItem(name: 'heart', icon: Icons.favorite, category: 'رموز'),
      IconItem(name: 'thumb_up', icon: Icons.thumb_up, category: 'رموز'),
      IconItem(name: 'thumb_down', icon: Icons.thumb_down, category: 'رموز'),
      IconItem(name: 'share', icon: Icons.share, category: 'رموز'),
      IconItem(name: 'lock', icon: Icons.lock, category: 'رموز'),
      IconItem(name: 'key', icon: Icons.vpn_key, category: 'رموز'),
      IconItem(name: 'bell', icon: Icons.notifications, category: 'رموز'),
      IconItem(name: 'flag', icon: Icons.flag, category: 'رموز'),

      // وجوه
      IconItem(name: 'smile', icon: Icons.sentiment_satisfied, category: 'وجوه'),
      IconItem(name: 'sad', icon: Icons.sentiment_dissatisfied, category: 'وجوه'),
      IconItem(name: 'happy', icon: Icons.sentiment_very_satisfied, category: 'وجوه'),
      IconItem(name: 'angry', icon: Icons.sentiment_very_dissatisfied, category: 'وجوه'),
      IconItem(name: 'neutral', icon: Icons.sentiment_neutral, category: 'وجوه'),
    ];
  }

  void _filterIcons() {
    setState(() {
      if (_selectedCategory == 'الكل') {
        _filteredIcons = _allIcons;
      } else {
        _filteredIcons = _allIcons.where((i) => i.category == _selectedCategory).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('مكتبة الأيقونات (${_filteredIcons.length})')),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                final selected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => _selectedCategory = cat);
                      _filterIcons();
                    },
                    selectedColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _filteredIcons.length,
              itemBuilder: (ctx, i) {
                final item = _filteredIcons[i];
                return GestureDetector(
                  onTap: () {
                    widget.onIconSelected(item.icon);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم اختيار ${item.name}')),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Icon(
                      item.icon,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
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

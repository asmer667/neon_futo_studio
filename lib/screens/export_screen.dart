import 'package:flutter/material.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  final List<Map<String, String>> _history = [
    {'name': 'my_theme_2026.zip', 'date': 'منذ ساعة', 'size': '2.4 KB', 'status': 'success'},
    {'name': 'neon_theme.zip', 'date': 'منذ 3 ساعات', 'size': '5.7 KB', 'status': 'success'},
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('الاستيراد والتصدير')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // عنوان
          const Text('استيراد أو تصدير مشاريعك بسهولة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text('اختر من بين عدة صيغ مدعومة', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 25),

          // بطاقات الاستيراد والتصدير
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.upload_file,
                  title: 'استيراد',
                  subtitle: 'استورد ملف ZIP أو JSON',
                  color: Colors.green,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('سيتم تفعيل الاستيراد قريباً')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.download,
                  title: 'تصدير',
                  subtitle: 'احفظ مشروعك كملف ZIP',
                  color: Colors.purple,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('استخدم زر التصدير داخل المحرر')),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // الصيغ المدعومة
          const Text('الصيغ المدعومة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildFormatChip('PNG', Icons.image, Colors.blue),
              _buildFormatChip('SVG', Icons.code, Colors.orange),
              _buildFormatChip('JSON', Icons.data_object, Colors.teal),
              _buildFormatChip('ZIP', Icons.folder_zip, Colors.purple),
            ],
          ),

          const SizedBox(height: 30),

          // سجل العمليات
          const Text('سجل العمليات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ..._history.map((item) => Card(
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (item['status'] == 'success' ? Colors.green : Colors.red).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  item['status'] == 'success' ? Icons.check : Icons.error,
                  color: item['status'] == 'success' ? Colors.green : Colors.red,
                ),
              ),
              title: Text(item['name']!),
              subtitle: Text('${item['date']} • ${item['size']}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.9), color.withOpacity(0.4)],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 5),
            Text(subtitle, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatChip(String label, IconData icon, Color color) {
    return Chip(
      avatar: Icon(icon, size: 18, color: color),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: color.withOpacity(0.15),
      side: BorderSide(color: color.withOpacity(0.5)),
    );
  }
}

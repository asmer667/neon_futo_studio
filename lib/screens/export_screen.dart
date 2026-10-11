import 'package:flutter/material.dart';
import '../services/zip_importer.dart';
import '../services/history_service.dart';
import 'editor_screen.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  List<Map<String, String>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final h = await HistoryService.getHistory();
    setState(() => _history = h.map((e) => Map<String, String>.from(e)).toList());
  }

  Future<void> _importTheme() async {
    try {
      final importer = ZipImporter();
      final theme = await importer.importTheme();
      if (theme != null && mounted) {
        await HistoryService.addOperation('${theme.name}.zip', 'import', '-');
        await _loadHistory();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditorScreen(initialTheme: theme)),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ تم استيراد: ${theme.name}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ خطأ: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الاستيراد والتصدير')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('استيراد أو تصدير مشاريعك بسهولة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text('اختر من بين عدة صيغ مدعومة', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 25),

          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.upload_file,
                  title: 'استيراد',
                  subtitle: 'استورد ملف ZIP',
                  color: Colors.green,
                  onTap: _importTheme,
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

          const Text('سجل العمليات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (_history.isEmpty)
            const Card(
              child: ListTile(
                leading: Icon(Icons.history),
                title: Text('لا توجد عمليات بعد'),
              ),
            ),
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

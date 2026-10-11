import 'package:flutter/material.dart';

class GenerateRectangleScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onGenerate;
  const GenerateRectangleScreen({super.key, required this.onGenerate});

  @override
  State<GenerateRectangleScreen> createState() => _GenerateRectangleScreenState();
}

class _GenerateRectangleScreenState extends State<GenerateRectangleScreen> {
  double diagonal = 170;
  double aspect = 1.0;
  double roundedness = 70;
  double padding = 0;
  Color bgColor = Colors.white;
  Color fgColor = Colors.black;
  String text = '';

  @override
  Widget build(BuildContext context) {
    final width = diagonal / (1 + aspect);
    final height = width * aspect;

    return Scaffold(
      appBar: AppBar(title: const Text('Generate Rectangle')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // المعاينة
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular((roundedness / 100) * (height / 2)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(color: fgColor, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          _buildSlider('Diagonal', diagonal, 50, 300, (v) => setState(() => diagonal = v)),
          _buildSlider('Aspect', aspect, 0.5, 3.0, (v) => setState(() => aspect = v)),
          _buildSlider('Roundedness', roundedness, 0, 100, (v) => setState(() => roundedness = v)),
          _buildSlider('Padding', padding, 0, 50, (v) => setState(() => padding = v)),

          const SizedBox(height: 20),
          const Text('Background:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildColorPicker(bgColor, (c) => setState(() => bgColor = c)),

          const SizedBox(height: 20),
          const Text('Foreground:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildColorPicker(fgColor, (c) => setState(() => fgColor = c)),

          const SizedBox(height: 20),
          const Text('Text:', style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(
            onChanged: (v) => setState(() => text = v),
            decoration: const InputDecoration(
              hintText: 'اكتب نصاً (اختياري)',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    widget.onGenerate({
                      'diagonal': diagonal,
                      'aspect': aspect,
                      'roundedness': roundedness,
                      'padding': padding,
                      'bgColor': bgColor,
                      'fgColor': fgColor,
                      'text': text,
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Insert'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: ${value.toStringAsFixed(1)}'),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  Widget _buildColorPicker(Color current, Function(Color) onPick) {
    final colors = [
      Colors.white, Colors.black, Colors.red, Colors.pink, Colors.purple,
      Colors.deepPurple, Colors.indigo, Colors.blue, Colors.cyan, Colors.teal,
      Colors.green, Colors.yellow, Colors.orange, Colors.deepOrange, Colors.brown,
      Colors.grey, Colors.blueGrey,
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: colors.map((c) => GestureDetector(
        onTap: () => onPick(c),
        child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: c,
            shape: BoxShape.circle,
            border: Border.all(
              color: current == c ? Colors.purple : Colors.white24,
              width: current == c ? 3 : 1,
            ),
          ),
        ),
      )).toList(),
    );
  }
}

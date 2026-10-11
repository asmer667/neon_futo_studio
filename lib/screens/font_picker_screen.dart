import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontPickerScreen extends StatefulWidget {
  final Function(String) onFontSelected;
  final String? currentFont;
  const FontPickerScreen({super.key, required this.onFontSelected, this.currentFont});

  @override
  State<FontPickerScreen> createState() => _FontPickerScreenState();
}

class _FontPickerScreenState extends State<FontPickerScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _loadingFonts = {};

  final List<String> _categories = [
    'All', 'Sans Serif', 'Serif', 'Display', 'Handwriting', 'Monospace', 'Arabic'
  ];

  // قائمة خطوط Google Fonts الواسعة
  final List<Map<String, String>> _fonts = [
    // Sans Serif
    {'name': 'Roboto', 'family': 'Roboto', 'category': 'Sans Serif'},
    {'name': 'Open Sans', 'family': 'Open Sans', 'category': 'Sans Serif'},
    {'name': 'Lato', 'family': 'Lato', 'category': 'Sans Serif'},
    {'name': 'Montserrat', 'family': 'Montserrat', 'category': 'Sans Serif'},
    {'name': 'Poppins', 'family': 'Poppins', 'category': 'Sans Serif'},
    {'name': 'Inter', 'family': 'Inter', 'category': 'Sans Serif'},
    {'name': 'Nunito', 'family': 'Nunito', 'category': 'Sans Serif'},
    {'name': 'Rubik', 'family': 'Rubik', 'category': 'Sans Serif'},
    {'name': 'Work Sans', 'family': 'Work Sans', 'category': 'Sans Serif'},
    {'name': 'Fira Sans', 'family': 'Fira Sans', 'category': 'Sans Serif'},
    {'name': 'Ubuntu', 'family': 'Ubuntu', 'category': 'Sans Serif'},
    {'name': 'Quicksand', 'family': 'Quicksand', 'category': 'Sans Serif'},
    {'name': 'Mulish', 'family': 'Mulish', 'category': 'Sans Serif'},
    {'name': 'Karla', 'family': 'Karla', 'category': 'Sans Serif'},
    {'name': 'Manrope', 'family': 'Manrope', 'category': 'Sans Serif'},
    {'name': 'DM Sans', 'family': 'DM Sans', 'category': 'Sans Serif'},
    {'name': 'Outfit', 'family': 'Outfit', 'category': 'Sans Serif'},
    {'name': 'Sora', 'family': 'Sora', 'category': 'Sans Serif'},
    {'name': 'Space Grotesk', 'family': 'Space Grotesk', 'category': 'Sans Serif'},
    {'name': 'Raleway', 'family': 'Raleway', 'category': 'Sans Serif'},

    // Serif
    {'name': 'Playfair Display', 'family': 'Playfair Display', 'category': 'Serif'},
    {'name': 'Merriweather', 'family': 'Merriweather', 'category': 'Serif'},
    {'name': 'Lora', 'family': 'Lora', 'category': 'Serif'},
    {'name': 'PT Serif', 'family': 'PT Serif', 'category': 'Serif'},
    {'name': 'Noto Serif', 'family': 'Noto Serif', 'category': 'Serif'},
    {'name': 'Source Serif Pro', 'family': 'Source Serif Pro', 'category': 'Serif'},
    {'name': 'Crimson Text', 'family': 'Crimson Text', 'category': 'Serif'},
    {'name': 'EB Garamond', 'family': 'EB Garamond', 'category': 'Serif'},
    {'name': 'Libre Baskerville', 'family': 'Libre Baskerville', 'category': 'Serif'},
    {'name': 'Cormorant Garamond', 'family': 'Cormorant Garamond', 'category': 'Serif'},

    // Display
    {'name': 'Oswald', 'family': 'Oswald', 'category': 'Display'},
    {'name': 'Bebas Neue', 'family': 'Bebas Neue', 'category': 'Display'},
    {'name': 'Anton', 'family': 'Anton', 'category': 'Display'},
    {'name': 'Righteous', 'family': 'Righteous', 'category': 'Display'},
    {'name': 'Abril Fatface', 'family': 'Abril Fatface', 'category': 'Display'},
    {'name': 'Alfa Slab One', 'family': 'Alfa Slab One', 'category': 'Display'},
    {'name': 'Bungee', 'family': 'Bungee', 'category': 'Display'},
    {'name': 'Fredoka One', 'family': 'Fredoka One', 'category': 'Display'},
    {'name': 'Lobster', 'family': 'Lobster', 'category': 'Display'},

    // Handwriting
    {'name': 'Dancing Script', 'family': 'Dancing Script', 'category': 'Handwriting'},
    {'name': 'Indie Flower', 'family': 'Indie Flower', 'category': 'Handwriting'},
    {'name': 'Shadows Into Light', 'family': 'Shadows Into Light', 'category': 'Handwriting'},
    {'name': 'Caveat', 'family': 'Caveat', 'category': 'Handwriting'},
    {'name': 'Satisfy', 'family': 'Satisfy', 'category': 'Handwriting'},
    {'name': 'Great Vibes', 'family': 'Great Vibes', 'category': 'Handwriting'},
    {'name': 'Sacramento', 'family': 'Sacramento', 'category': 'Handwriting'},
    {'name': 'Kalam', 'family': 'Kalam', 'category': 'Handwriting'},
    {'name': 'Patrick Hand', 'family': 'Patrick Hand', 'category': 'Handwriting'},
    {'name': 'Architects Daughter', 'family': 'Architects Daughter', 'category': 'Handwriting'},
    {'name': 'Pacifico', 'family': 'Pacifico', 'category': 'Handwriting'},

    // Monospace
    {'name': 'Roboto Mono', 'family': 'Roboto Mono', 'category': 'Monospace'},
    {'name': 'Source Code Pro', 'family': 'Source Code Pro', 'category': 'Monospace'},
    {'name': 'JetBrains Mono', 'family': 'JetBrains Mono', 'category': 'Monospace'},
    {'name': 'Fira Code', 'family': 'Fira Code', 'category': 'Monospace'},
    {'name': 'Inconsolata', 'family': 'Inconsolata', 'category': 'Monospace'},
    {'name': 'Space Mono', 'family': 'Space Mono', 'category': 'Monospace'},
    {'name': 'IBM Plex Mono', 'family': 'IBM Plex Mono', 'category': 'Monospace'},
    {'name': 'Courier Prime', 'family': 'Courier Prime', 'category': 'Monospace'},

    // Arabic (خطوط عربية)
    {'name': 'Cairo', 'family': 'Cairo', 'category': 'Arabic'},
    {'name': 'Tajawal', 'family': 'Tajawal', 'category': 'Arabic'},
    {'name': 'Amiri', 'family': 'Amiri', 'category': 'Arabic'},
    {'name': 'Almarai', 'family': 'Almarai', 'category': 'Arabic'},
    {'name': 'Changa', 'family': 'Changa', 'category': 'Arabic'},
    {'name': 'El Messiri', 'family': 'El Messiri', 'category': 'Arabic'},
    {'name': 'Harmattan', 'family': 'Harmattan', 'category': 'Arabic'},
    {'name': 'Lateef', 'family': 'Lateef', 'category': 'Arabic'},
    {'name': 'Lemonada', 'family': 'Lemonada', 'category': 'Arabic'},
    {'name': 'Mada', 'family': 'Mada', 'category': 'Arabic'},
    {'name': 'Markazi Text', 'family': 'Markazi Text', 'category': 'Arabic'},
    {'name': 'Mirza', 'family': 'Mirza', 'category': 'Arabic'},
    {'name': 'Reem Kufi', 'family': 'Reem Kufi', 'category': 'Arabic'},
    {'name': 'Scheherazade', 'family': 'Scheherazade', 'category': 'Arabic'},
    {'name': 'Aref Ruqaa', 'family': 'Aref Ruqaa', 'category': 'Arabic'},
    {'name': 'Lalezar', 'family': 'Lalezar', 'category': 'Arabic'},
    {'name': 'Rakkas', 'family': 'Rakkas', 'category': 'Arabic'},
    {'name': 'Katibeh', 'family': 'Katibeh', 'category': 'Arabic'},
  ];

  List<Map<String, String>> get _filteredFonts {
    return _fonts.where((f) {
      final matchCategory = _selectedCategory == 'All' || f['category'] == _selectedCategory;
      final matchSearch = _searchController.text.isEmpty ||
          f['name']!.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  /// الحصول على TextStyle باستخدام Google Fonts ديناميكياً
  TextStyle _getGoogleFontStyle(String family, {double size = 18, FontWeight weight = FontWeight.normal}) {
    try {
      // استخدام GoogleFonts.textStyle للخط
      switch (family) {
        case 'Roboto': return GoogleFonts.roboto(fontSize: size, fontWeight: weight);
        case 'Open Sans': return GoogleFonts.openSans(fontSize: size, fontWeight: weight);
        case 'Lato': return GoogleFonts.lato(fontSize: size, fontWeight: weight);
        case 'Montserrat': return GoogleFonts.montserrat(fontSize: size, fontWeight: weight);
        case 'Poppins': return GoogleFonts.poppins(fontSize: size, fontWeight: weight);
        case 'Inter': return GoogleFonts.inter(fontSize: size, fontWeight: weight);
        case 'Nunito': return GoogleFonts.nunito(fontSize: size, fontWeight: weight);
        case 'Rubik': return GoogleFonts.rubik(fontSize: size, fontWeight: weight);
        case 'Work Sans': return GoogleFonts.workSans(fontSize: size, fontWeight: weight);
        case 'Fira Sans': return GoogleFonts.firaSans(fontSize: size, fontWeight: weight);
        case 'Ubuntu': return GoogleFonts.ubuntu(fontSize: size, fontWeight: weight);
        case 'Quicksand': return GoogleFonts.quicksand(fontSize: size, fontWeight: weight);
        case 'Mulish': return GoogleFonts.mulish(fontSize: size, fontWeight: weight);
        case 'Karla': return GoogleFonts.karla(fontSize: size, fontWeight: weight);
        case 'Manrope': return GoogleFonts.manrope(fontSize: size, fontWeight: weight);
        case 'DM Sans': return GoogleFonts.dmSans(fontSize: size, fontWeight: weight);
        case 'Outfit': return GoogleFonts.outfit(fontSize: size, fontWeight: weight);
        case 'Sora': return GoogleFonts.sora(fontSize: size, fontWeight: weight);
        case 'Space Grotesk': return GoogleFonts.spaceGrotesk(fontSize: size, fontWeight: weight);
        case 'Raleway': return GoogleFonts.raleway(fontSize: size, fontWeight: weight);
        case 'Playfair Display': return GoogleFonts.playfairDisplay(fontSize: size, fontWeight: weight);
        case 'Merriweather': return GoogleFonts.merriweather(fontSize: size, fontWeight: weight);
        case 'Lora': return GoogleFonts.lora(fontSize: size, fontWeight: weight);
        case 'PT Serif': return GoogleFonts.ptSerif(fontSize: size, fontWeight: weight);
        case 'Noto Serif': return GoogleFonts.notoSerif(fontSize: size, fontWeight: weight);
        case 'Source Serif Pro': return GoogleFonts.sourceSerif4(fontSize: size, fontWeight: weight);
        case 'Crimson Text': return GoogleFonts.crimsonText(fontSize: size, fontWeight: weight);
        case 'EB Garamond': return GoogleFonts.ebGaramond(fontSize: size, fontWeight: weight);
        case 'Libre Baskerville': return GoogleFonts.libreBaskerville(fontSize: size, fontWeight: weight);
        case 'Cormorant Garamond': return GoogleFonts.cormorantGaramond(fontSize: size, fontWeight: weight);
        case 'Oswald': return GoogleFonts.oswald(fontSize: size, fontWeight: weight);
        case 'Bebas Neue': return GoogleFonts.bebasNeue(fontSize: size, fontWeight: weight);
        case 'Anton': return GoogleFonts.anton(fontSize: size, fontWeight: weight);
        case 'Righteous': return GoogleFonts.righteous(fontSize: size, fontWeight: weight);
        case 'Abril Fatface': return GoogleFonts.abrilFatface(fontSize: size, fontWeight: weight);
        case 'Alfa Slab One': return GoogleFonts.alfaSlabOne(fontSize: size, fontWeight: weight);
        case 'Bungee': return GoogleFonts.bungee(fontSize: size, fontWeight: weight);
        case 'Fredoka One': return GoogleFonts.fredoka(fontSize: size, fontWeight: weight);
        case 'Lobster': return GoogleFonts.lobster(fontSize: size, fontWeight: weight);
        case 'Dancing Script': return GoogleFonts.dancingScript(fontSize: size, fontWeight: weight);
        case 'Indie Flower': return GoogleFonts.indieFlower(fontSize: size, fontWeight: weight);
        case 'Shadows Into Light': return GoogleFonts.shadowsIntoLight(fontSize: size, fontWeight: weight);
        case 'Caveat': return GoogleFonts.caveat(fontSize: size, fontWeight: weight);
        case 'Satisfy': return GoogleFonts.satisfy(fontSize: size, fontWeight: weight);
        case 'Great Vibes': return GoogleFonts.greatVibes(fontSize: size, fontWeight: weight);
        case 'Sacramento': return GoogleFonts.sacramento(fontSize: size, fontWeight: weight);
        case 'Kalam': return GoogleFonts.kalam(fontSize: size, fontWeight: weight);
        case 'Patrick Hand': return GoogleFonts.patrickHand(fontSize: size, fontWeight: weight);
        case 'Architects Daughter': return GoogleFonts.architectsDaughter(fontSize: size, fontWeight: weight);
        case 'Pacifico': return GoogleFonts.pacifico(fontSize: size, fontWeight: weight);
        case 'Roboto Mono': return GoogleFonts.robotoMono(fontSize: size, fontWeight: weight);
        case 'Source Code Pro': return GoogleFonts.sourceCodePro(fontSize: size, fontWeight: weight);
        case 'JetBrains Mono': return GoogleFonts.jetBrainsMono(fontSize: size, fontWeight: weight);
        case 'Fira Code': return GoogleFonts.firaCode(fontSize: size, fontWeight: weight);
        case 'Inconsolata': return GoogleFonts.inconsolata(fontSize: size, fontWeight: weight);
        case 'Space Mono': return GoogleFonts.spaceMono(fontSize: size, fontWeight: weight);
        case 'IBM Plex Mono': return GoogleFonts.ibmPlexMono(fontSize: size, fontWeight: weight);
        case 'Courier Prime': return GoogleFonts.courierPrime(fontSize: size, fontWeight: weight);
        case 'Cairo': return GoogleFonts.cairo(fontSize: size, fontWeight: weight);
        case 'Tajawal': return GoogleFonts.tajawal(fontSize: size, fontWeight: weight);
        case 'Amiri': return GoogleFonts.amiri(fontSize: size, fontWeight: weight);
        case 'Almarai': return GoogleFonts.almarai(fontSize: size, fontWeight: weight);
        case 'Changa': return GoogleFonts.changa(fontSize: size, fontWeight: weight);
        case 'El Messiri': return GoogleFonts.elMessiri(fontSize: size, fontWeight: weight);
        case 'Harmattan': return GoogleFonts.harmattan(fontSize: size, fontWeight: weight);
        case 'Lateef': return GoogleFonts.lateef(fontSize: size, fontWeight: weight);
        case 'Lemonada': return GoogleFonts.lemonada(fontSize: size, fontWeight: weight);
        case 'Mada': return GoogleFonts.mada(fontSize: size, fontWeight: weight);
        case 'Markazi Text': return GoogleFonts.markaziText(fontSize: size, fontWeight: weight);
        case 'Mirza': return GoogleFonts.mirza(fontSize: size, fontWeight: weight);
        case 'Reem Kufi': return GoogleFonts.reemKufi(fontSize: size, fontWeight: weight);
        case 'Scheherazade': return GoogleFonts.scheherazadeNew(fontSize: size, fontWeight: weight);
        case 'Aref Ruqaa': return GoogleFonts.arefRuqaa(fontSize: size, fontWeight: weight);
        case 'Lalezar': return GoogleFonts.lalezar(fontSize: size, fontWeight: weight);
        case 'Rakkas': return GoogleFonts.rakkas(fontSize: size, fontWeight: weight);
        case 'Katibeh': return GoogleFonts.katibeh(fontSize: size, fontWeight: weight);
        default: return TextStyle(fontSize: size, fontWeight: weight);
      }
    } catch (e) {
      return TextStyle(fontSize: size, fontWeight: weight);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Font Picker')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search fonts...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                final selected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: Colors.purple,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredFonts.length,
              itemBuilder: (ctx, i) {
                final font = _filteredFonts[i];
                final isSelected = widget.currentFont == font['family'];
                final isLoading = _loadingFonts.contains(font['family']);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    title: Text(
                      font['name']!,
                      style: _getGoogleFontStyle(font['family']!, size: 18, weight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'AaBbCc 0123 ابجد',
                      style: _getGoogleFontStyle(font['family']!, size: 16),
                    ),
                    trailing: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : (isSelected
                            ? const Icon(Icons.check, color: Colors.purple)
                            : Text(font['category']!, style: const TextStyle(fontSize: 10))),
                    onTap: () async {
                      setState(() => _loadingFonts.add(font['family']!));
                      try {
                        // تحميل الخط من Google Fonts
                        await GoogleFonts.pendingFonts();
                        widget.onFontSelected(font['family']!);
                        Navigator.pop(context);
                      } catch (e) {
                        setState(() => _loadingFonts.remove(font['family']!));
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('فشل تحميل الخط: $e')),
                          );
                        }
                      }
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

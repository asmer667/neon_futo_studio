import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'main_layout.dart';

void main() {
  runApp(const NeonFutoApp());
}

class NeonFutoApp extends StatelessWidget {
  const NeonFutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'NEON FUTO STUDIO',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: darkDynamic?.copyWith(
              primary: const Color(0xFF6C63FF),
              secondary: const Color(0xFF00D2FF),
              surface: const Color(0xFF1A1A2E),
            ) ??
                ColorScheme.fromSeed(
                  seedColor: const Color(0xFF6C63FF),
                  brightness: Brightness.dark,
                ),
            scaffoldBackgroundColor: const Color(0xFF0F0F1A),
            cardTheme: CardTheme(
              color: const Color(0xFF1A1A2E),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
            ),
          ),
          home: const MainLayout(),
        );
      },
    );
  }
}

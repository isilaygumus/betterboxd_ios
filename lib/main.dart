import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // ---- BURAYI EKLEDİK / DEĞİŞTİRDİK ----
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF14181C), // Letterboxd koyu arka planı
        primaryColor: const Color(0xFF00E054),            // Letterboxd yeşili
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E054),
          secondary: Color(0xFF00E054),                    // Mavi vurgular
          surface: Color(0xFF1C2228),                      // Kart ve AppBar yüzey rengi
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF14181C),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      // --------------------------------------
      home: const MainScreen(),
    );
  }
}
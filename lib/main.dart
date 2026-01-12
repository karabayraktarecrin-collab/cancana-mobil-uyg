import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'intro_page.dart';
import 'ana_sayfa.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CanCanaApp());
}

class CanCanaApp extends StatelessWidget {
  const CanCanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CanCana Yardımlaşma',
      theme: ThemeData(
        useMaterial3: true,

        // RENK PALETİ
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF283593),
          secondary: const Color(0xFF00BFA5),
          background: const Color(0xFFF5F5F7),
        ),

        // APP BAR
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF283593),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1),
        ),

        // KART TASARIMI (HATA BURADAYDI, DÜZELTİLDİ)
        // CardTheme yerine CardThemeData kullanıldı
        cardTheme: CardThemeData(
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        ),

        // BUTONLAR
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF283593),
            foregroundColor: Colors.white,
            elevation: 3,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),

        // YAZI KUTULARI
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF283593), width: 2),
          ),
          prefixIconColor: const Color(0xFF283593),
        ),
      ),

      home: FirebaseAuth.instance.currentUser != null
          ? const AnaSayfa()
          : const IntroPage(),
    );
  }
}
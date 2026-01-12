import 'package:flutter/material.dart';
import 'register_page.dart'; // Bitişte buraya gidecek

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  // Tanıtım Sayfaları Verisi
  List<Map<String, dynamic>> slides = [
    {
      "title": "Yardımlaşma Ağı",
      "text": "İhtiyacın olan ders notu, kitap veya eşyayı iste, topluluk sana destek olsun.",
      "icon": Icons.volunteer_activism,
      "color": const Color(0xFF1A237E)
    },
    {
      "title": "Can Sistemi ❤️",
      "text": "Herkesin 3 Canı var! Yardım istediğinde 1 Can azalır. Can kazanmak için başkalarına yardım etmelisin.",
      "icon": Icons.favorite,
      "color": Colors.redAccent
    },
    {
      "title": "Puan Topla Lider Ol",
      "text": "Yardım ettikçe puan ve yıldız kazan. Güvenilirlik rozetlerini topla!",
      "icon": Icons.emoji_events,
      "color": Colors.amber
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // İKON ALANI
                        Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: (slides[index]["color"] as Color).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            slides[index]["icon"],
                            size: 100,
                            color: slides[index]["color"],
                          ),
                        ),
                        const SizedBox(height: 40),
                        // BAŞLIK
                        Text(
                          slides[index]["title"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: slides[index]["color"]
                          ),
                        ),
                        const SizedBox(height: 20),
                        // AÇIKLAMA
                        Text(
                          slides[index]["text"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ALT KISIM (NOKTALAR VE BUTON)
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Sayfa Noktaları
                  Row(
                    children: List.generate(
                      slides.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 5),
                        height: 10,
                        width: _currentPage == index ? 25 : 10,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? const Color(0xFF1A237E) : Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),

                  // İleri / Başla Butonu
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == slides.length - 1) {
                        // Son sayfadaysa Kayıt Ekranına git ve burayı kapat
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage())
                        );
                      } else {
                        // Değilse sonraki sayfaya kaydır
                        _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A237E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    ),
                    child: Text(_currentPage == slides.length - 1 ? "BAŞLA" : "İLERİ"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
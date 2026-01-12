import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('kullanicilar').doc(user!.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final data = snapshot.data!.data() as Map<String, dynamic>?;

          final int kalanCan = data?['kalanCan'] ?? 0;
          final int puan = data?['yardimPuani'] ?? 0;

          // YILDIZ HESAPLAMASI
          final num toplamYildiz = data?['toplamYildiz'] ?? 0;
          final num degerlendirmeSayisi = data?['degerlendirmeSayisi'] ?? 0;

          // Sıfıra bölünme hatasını önlemek için kontrol
          double ortalamaPuan = 0.0;
          if (degerlendirmeSayisi > 0) {
            ortalamaPuan = toplamYildiz / degerlendirmeSayisi;
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // PROFİL BAŞLIĞI
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Color(0xFF1A237E),
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.email!.split('@')[0],
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Text(user.email!, style: const TextStyle(color: Colors.grey)),

                    const SizedBox(height: 15),

                    // GÜVENİLİRLİK PUANI KARTI (YENİ)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.amber[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amber),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Güvenilirlik: ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)),
                          Text(
                            "${ortalamaPuan.toStringAsFixed(1)} / 5.0", // Örn: 4.8 / 5.0
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          Text(" ($degerlendirmeSayisi oy)", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // İSTATİSTİKLER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _istatistikKarti("Kalan Can", "$kalanCan ❤️", Colors.redAccent),
                  _istatistikKarti("Toplam Puan", "$puan 🏆", Colors.blue),
                ],
              ),

              const SizedBox(height: 30),
              const Text("Kazanılan Rozetler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),

              // ROZETLER (Örnek Mantık: Puan arttıkça rozetler açılır)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                children: [
                  _rozetKarti(Icons.verified, "Yeni Başlayan", true),
                  _rozetKarti(Icons.volunteer_activism, "Yardımsever", puan >= 50),
                  _rozetKarti(Icons.star, "Süper Kahraman", puan >= 100),
                  _rozetKarti(Icons.bolt, "Hızlı Cevap", puan >= 200),
                  _rozetKarti(Icons.diamond, "Elmas Kalp", puan >= 500),
                  _rozetKarti(Icons.shield, "Güvenilir", ortalamaPuan >= 4.5 && degerlendirmeSayisi > 5),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _istatistikKarti(String baslik, String deger, Color renk) {
    return Column(
      children: [
        Text(deger, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: renk)),
        Text(baslik, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _rozetKarti(IconData icon, String isim, bool kazanildi) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: kazanildi ? const Color(0xFF1A237E) : Colors.grey[300],
          child: Icon(icon, color: kazanildi ? Colors.amber : Colors.grey),
        ),
        const SizedBox(height: 5),
        Text(isim, style: TextStyle(fontSize: 12, color: kazanildi ? Colors.black : Colors.grey)),
      ],
    );
  }
}
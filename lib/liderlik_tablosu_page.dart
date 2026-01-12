import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LiderlikTablosuPage extends StatelessWidget {
  const LiderlikTablosuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🏆 Yardımseverler Liderlik Tablosu")),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.blue.shade50],
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          // Kullanıcıları puana göre sırala (En yüksek en üstte)
          stream: FirebaseFirestore.instance
              .collection('kullanicilar')
              .orderBy('yardimPuani', descending: true)
              .limit(20) // İlk 20 kişiyi göster
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("Henüz kimse puan kazanmadı!", style: TextStyle(color: Colors.white)));
            }

            final docs = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final email = data['email'] ?? 'Anonim';
                final puan = data['yardimPuani'] ?? 0;
                final can = data['kalanCan'] ?? 0;

                // İlk 3 kişi için özel simgeler
                Widget leadingIcon;
                if (index == 0) leadingIcon = const Text("🥇", style: TextStyle(fontSize: 30));
                else if (index == 1) leadingIcon = const Text("🥈", style: TextStyle(fontSize: 30));
                else if (index == 2) leadingIcon = const Text("🥉", style: TextStyle(fontSize: 30));
                else leadingIcon = Text("${index + 1}.", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18));

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: leadingIcon,
                    ),
                    title: Text(
                      email.split('@')[0], // @'den önceki kısmı isim olarak göster
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text("Mevcut Can: $can ❤️"),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "$puan Puan",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
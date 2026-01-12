import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  final String talepId;
  final String baslik;

  const ChatPage({super.key, required this.talepId, required this.baslik});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _mesajController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _secilenYildiz = 5; // Varsayılan puan

  // Mesaj Gönderme
  void _mesajGonder() async {
    if (_mesajController.text.trim().isEmpty) return;
    final user = _auth.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('talepler').doc(widget.talepId).collection('mesajlar').add({
      'mesaj': _mesajController.text.trim(),
      'gonderen': user.email,
      'tarih': FieldValue.serverTimestamp(),
    });
    _mesajController.clear();
  }

  // YARDIMI TAMAMLAMA VE YILDIZ VERME
  void _yardimiTamamlaDialog() {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        // Dialog içinde state değişimi için StatefulBuilder kullanıyoruz
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Yardımı Onayla & Puanla"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Sana yardım eden kişinin e-postasını gir ve hizmet kalitesini puanla:"),
                  const SizedBox(height: 15),

                  // YILDIZ SEÇİMİ (Basit ve Etkili)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < _secilenYildiz ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                        onPressed: () {
                          setStateDialog(() {
                            _secilenYildiz = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  Text("Verilen Puan: $_secilenYildiz/5", style: const TextStyle(fontWeight: FontWeight.bold)),

                  const SizedBox(height: 15),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: "Yardımcının E-postası",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
                ElevatedButton(
                  onPressed: () => _puaniIsleVeKapat(emailController.text.trim()),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white),
                  child: const Text("Onayla"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _puaniIsleVeKapat(String hedefEmail) async {
    if (hedefEmail.isEmpty) return;
    Navigator.pop(context);

    try {
      final query = await FirebaseFirestore.instance.collection('kullanicilar').where('email', isEqualTo: hedefEmail).get();

      if (query.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bu e-posta ile kayıtlı kullanıcı bulunamadı!")));
        return;
      }

      final yardimEdenRef = query.docs.first.reference;

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final tSnapshot = await transaction.get(yardimEdenRef);
        final mevcutCan = tSnapshot.data()?['kalanCan'] ?? 0;
        final mevcutPuan = tSnapshot.data()?['yardimPuani'] ?? 0;

        // Yıldız verilerini al (Eğer yoksa 0 kabul et)
        final mevcutToplamYildiz = tSnapshot.data()?['toplamYildiz'] ?? 0;
        final mevcutDegerlendirmeSayisi = tSnapshot.data()?['degerlendirmeSayisi'] ?? 0;

        // VERİTABANI GÜNCELLEMESİ
        transaction.update(yardimEdenRef, {
          'kalanCan': mevcutCan + 1,        // Can Kazanır
          'yardimPuani': mevcutPuan + 10,   // Puan Kazanır
          'toplamYildiz': mevcutToplamYildiz + _secilenYildiz,     // Yıldız ekle
          'degerlendirmeSayisi': mevcutDegerlendirmeSayisi + 1,    // Oy sayısını artır
        });

        // Talebi Kapat
        final talepRef = FirebaseFirestore.instance.collection('talepler').doc(widget.talepId);
        transaction.update(talepRef, {'durum': 'tamamlandi'});
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Teşekkürler! Puan ve Yıldız verildi.")));
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.baslik),
        actions: [
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('talepler').doc(widget.talepId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              final data = snapshot.data!.data() as Map<String, dynamic>;
              final sahibi = data['kullaniciEmail'];
              final durum = data['durum'] ?? 'aktif';

              if (sahibi == _auth.currentUser?.email && durum == 'aktif') {
                return TextButton.icon(
                  onPressed: _yardimiTamamlaDialog,
                  icon: const Icon(Icons.check_circle, color: Colors.greenAccent),
                  label: const Text("TAMAMLA", style: TextStyle(color: Colors.white)),
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('talepler').doc(widget.talepId).collection('mesajlar').orderBy('tarih').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final msg = docs[index].data() as Map<String, dynamic>;
                    final isMe = msg['gonderen'] == _auth.currentUser?.email;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? const Color(0xFFE8EAF6) : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(msg['mesaj'] ?? ''),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _mesajController,
                    decoration: InputDecoration(
                      hintText: "Mesaj yaz...",
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: const Color(0xFF1A237E),
                  child: IconButton(icon: const Icon(Icons.send, color: Colors.white), onPressed: _mesajGonder),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TalepFormuPage extends StatefulWidget {
  const TalepFormuPage({super.key});

  @override
  State<TalepFormuPage> createState() => _TalepFormuPageState();
}

class _TalepFormuPageState extends State<TalepFormuPage> {
  final _baslikController = TextEditingController();
  final _aciklamaController = TextEditingController();

  final List<String> _kategoriler = ['Kitap/Kırtasiye', 'Giyim', 'Yiyecek', 'Elektronik', 'Diğer'];
  String? _secilenKategori;
  bool _yukleniyor = false;

  void _talepOlustur() async {
    if (_secilenKategori == null || _baslikController.text.isEmpty || _aciklamaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen tüm alanları doldurunuz.")));
      return;
    }

    setState(() => _yukleniyor = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance.collection('kullanicilar').doc(user.uid);
    final talepRef = FirebaseFirestore.instance.collection('talepler').doc();

    try {
      // TRANSACTION: Aynı anda veri okuyup yazma işlemi (Güvenli Can Düşme)
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userDoc = await transaction.get(userRef);

        if (!userDoc.exists) throw Exception("Kullanıcı verisi bulunamadı!");

        final mevcutCan = userDoc.data()?['kalanCan'] ?? 0;

        if (mevcutCan <= 0) {
          throw Exception("Yetersiz Can! Talep açmak için önce birine yardım edip can kazanmalısın.");
        }

        // 1. Kullanıcıdan 1 Can Düş
        transaction.update(userRef, {'kalanCan': mevcutCan - 1});

        // 2. Talebi Kaydet
        transaction.set(talepRef, {
          'kategori': _secilenKategori,
          'baslik': _baslikController.text.trim(),
          'aciklama': _aciklamaController.text.trim(),
          'kullaniciEmail': user.email,
          'kullaniciId': user.uid,
          'durum': 'aktif', // Yeni alan: Talep aktif mi tamamlandı mı?
          'tarih': FieldValue.serverTimestamp(),
        });
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Talep oluşturuldu! (1 Can Harcandı)")));
        Navigator.pop(context);
      }
    } catch (e) {
      // Hata mesajını temizleyip kullanıcıya gösteriyoruz
      String hataMesaji = e.toString().replaceAll("Exception: ", "");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(hataMesaji), backgroundColor: Colors.red));
      setState(() => _yukleniyor = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yardım İste (-1 ❤️)")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Kategori", border: OutlineInputBorder()),
              value: _secilenKategori,
              items: _kategoriler.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (v) => setState(() => _secilenKategori = v),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _baslikController,
              decoration: const InputDecoration(labelText: "Başlık", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _aciklamaController,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Açıklama", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _yukleniyor ? null : _talepOlustur,
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A237E), foregroundColor: Colors.white),
                child: _yukleniyor
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Talebi Yayınla (-1 Can)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
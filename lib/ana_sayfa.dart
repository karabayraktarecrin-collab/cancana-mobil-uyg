import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'talep_formu_page.dart';
import 'chat_page.dart';
import 'profil_page.dart';
import 'liderlik_tablosu_page.dart';
import 'register_page.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _seciliAltMenu = 0;

  String _aramaMetni = "";
  String _seciliKategori = "Tümü";
  final List<String> _kategoriler = ["Tümü", "Kitap/Kırtasiye", "Giyim", "Yiyecek", "Elektronik", "Diğer"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  // --- ÇIKIŞ YAPMA VE YÖNLENDİRME FONKSİYONU ---
  void _cikisYap() async {
    // 1. Firebase'den çık
    await FirebaseAuth.instance.signOut();


    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const RegisterPage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;


    if (_seciliAltMenu == 1) {
      return Scaffold(
        appBar: AppBar(title: const Text("Liderlik Tablosu")),
        body: const LiderlikTablosuPage(),
        bottomNavigationBar: _altMenu(),
      );
    } else if (_seciliAltMenu == 2) {
      return Scaffold(
        appBar: AppBar(title: const Text("Profilim")),
        body: const ProfilPage(),
        bottomNavigationBar: _altMenu(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("CanCana İmece"),
        actions: [
          // GÜNCELLENEN ÇIKIŞ BUTONU
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              tooltip: "Çıkış Yap",
              onPressed: _cikisYap
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [Tab(text: "BEKLEYENLER"), Tab(text: "TALEPLERİM")],
        ),
      ),
      body: Column(
        children: [
          // --- 1. HEADER (KULLANICI BİLGİSİ VE CANLAR) ---
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('kullanicilar').doc(user!.uid).snapshots(),
            builder: (context, snapshot) {
              String tamIsim = "Kullanıcı";
              int kalanCan = 0;

              if (snapshot.hasData && snapshot.data!.data() != null) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                kalanCan = data['kalanCan'] ?? 0;

                if (data.containsKey('ad') && data.containsKey('soyad')) {
                  tamIsim = "${data['ad']} ${data['soyad']}";
                } else {
                  tamIsim = user.email!.split('@')[0];
                }
              }

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                color: const Color(0xFF1A237E),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Merhaba, $tamIsim",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        const Text("Canlar: ", style: TextStyle(color: Colors.white70)),
                        for (int i = 0; i < 3; i++)
                          Icon(
                            i < kalanCan ? Icons.favorite : Icons.favorite_border,
                            color: Colors.red,
                            size: 20,
                          ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),

          // --- 2. ARAMA VE KATEGORİ ALANI ---
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[100],
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "İhtiyaç ara... (Örn: Kitap)",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  onChanged: (deger) => setState(() => _aramaMetni = deger.toLowerCase()),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _kategoriler.map((kategori) {
                      final bool secili = _seciliKategori == kategori;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(kategori),
                          selected: secili,
                          selectedColor: const Color(0xFF1A237E),
                          labelStyle: TextStyle(color: secili ? Colors.white : Colors.black),
                          onSelected: (bool selected) => setState(() => _seciliKategori = kategori),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // --- 3. LİSTELER ---
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _TalepListesi(
                    sadeceBenimkiler: false,
                    aktifEmail: user?.email,
                    aramaMetni: _aramaMetni,
                    seciliKategori: _seciliKategori
                ),
                _TalepListesi(
                    sadeceBenimkiler: true,
                    aktifEmail: user?.email,
                    aramaMetni: _aramaMetni,
                    seciliKategori: _seciliKategori
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TalepFormuPage())),
        label: const Text("YARDIM İSTE"),
        icon: const Icon(Icons.favorite),
        backgroundColor: Colors.redAccent,
      ),
      bottomNavigationBar: _altMenu(),
    );
  }

  Widget _altMenu() {
    return BottomNavigationBar(
      currentIndex: _seciliAltMenu,
      onTap: (index) => setState(() => _seciliAltMenu = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Anasayfa"),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Liderlik"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
      ],
      selectedItemColor: const Color(0xFF1A237E),
    );
  }
}

// --- GÜNCELLENMİŞ PREMIUM LİSTE WIDGET'I ---
class _TalepListesi extends StatelessWidget {
  final bool sadeceBenimkiler;
  final String? aktifEmail;
  final String aramaMetni;
  final String seciliKategori;

  const _TalepListesi({
    required this.sadeceBenimkiler,
    required this.aktifEmail,
    required this.aramaMetni,
    required this.seciliKategori,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('talepler').orderBy('tarih', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final email = data['kullaniciEmail'];
          final durum = data['durum'] ?? 'aktif';
          final baslik = (data['baslik'] ?? '').toString().toLowerCase();
          final kategori = data['kategori'] ?? '';

          if (durum != 'aktif' && !sadeceBenimkiler) return false;
          if (sadeceBenimkiler) {
            if (email != aktifEmail) return false;
          } else {
            if (email == aktifEmail) return false;
          }

          if (aramaMetni.isNotEmpty && !baslik.contains(aramaMetni)) return false;
          if (seciliKategori != "Tümü" && !kategori.toString().contains(seciliKategori.split('/')[0])) return false;

          return true;
        }).toList();

        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 50, color: Colors.grey[300]),
                const SizedBox(height: 10),
                const Text("Talep bulunamadı.", style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 10, bottom: 80),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final durum = data['durum'] ?? 'aktif';

            return Card(
              // Kenar yuvarlatma ve gölge zaten Theme'den geliyor
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ÜST KISIM: İKON, BAŞLIK VE TARİH
                    Row(
                      children: [
                        // Kategori İkonu (Renkli Kutu içinde)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: _kategoriRengi(data['kategori']).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _kategoriIkonu(data['kategori']),
                            color: _kategoriRengi(data['kategori']),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Başlık ve Kategori İsmi
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['baslik'] ?? 'Başlık Yok',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              // Kategori Etiketi
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  data['kategori'] ?? 'Genel',
                                  style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Durum Rozeti (Sağ Üst)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: durum == 'tamamlandi' ? Colors.green[50] : Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: durum == 'tamamlandi' ? Colors.green : Colors.orange,
                                width: 0.5
                            ),
                          ),
                          child: Text(
                            durum == 'tamamlandi' ? 'Çözüldü' : 'Bekliyor',
                            style: TextStyle(
                              color: durum == 'tamamlandi' ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Colors.black12),
                    const SizedBox(height: 8),

                    // ALT KISIM: BUTONLAR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (sadeceBenimkiler)
                          TextButton.icon(
                            onPressed: () => _sohbeteGit(context, docs[index].id, data['baslik']),
                            icon: const Icon(Icons.chat_bubble_outline, size: 18),
                            label: const Text("Detaylar"),
                          )
                        else ...[
                          // Sadece Soru Sor
                          TextButton(
                            onPressed: () => _sohbeteGit(context, docs[index].id, data['baslik']),
                            style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
                            child: const Text("Soru Sor"),
                          ),
                          const SizedBox(width: 8),
                          // YARDIM ET (Premium Buton)
                          ElevatedButton.icon(
                            onPressed: () => _sohbeteGit(context, docs[index].id, data['baslik']),
                            icon: const Icon(Icons.volunteer_activism, size: 18),
                            label: const Text("Yardım Et"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00BFA5), // Canlı Teal Rengi
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _sohbeteGit(BuildContext context, String docId, String? baslik) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(talepId: docId, baslik: baslik ?? '')
        )
    );
  }

  Color _kategoriRengi(String? kat) {
    if (kat == null) return Colors.grey;
    if (kat.contains("Kitap")) return Colors.purple;
    if (kat.contains("Giyim")) return Colors.orange;
    if (kat.contains("Yiyecek")) return Colors.green;
    if (kat.contains("Elektronik")) return Colors.blue;
    return Colors.teal;
  }

  IconData _kategoriIkonu(String? kat) {
    if (kat == null) return Icons.help;
    if (kat.contains("Kitap")) return Icons.book;
    if (kat.contains("Giyim")) return Icons.checkroom;
    if (kat.contains("Yiyecek")) return Icons.restaurant;
    if (kat.contains("Elektronik")) return Icons.phone_android;
    return Icons.category;
  }
}
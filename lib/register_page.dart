import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ana_sayfa.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Kontrolcüler (Kutuların içindeki yazıları okumak için)
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _adController = TextEditingController();
  final _soyadController = TextEditingController();

  bool _isLoading = false;
  bool _isLoginMode = true; // Başlangıçta Giriş Modundayız

  // GİRİŞ YAPMA FONKSİYONU
  void _girisYap() async {
    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AnaSayfa()));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Hata: ${e.message}")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // KAYIT OLMA FONKSİYONU
  void _kayitOl() async {
    if (_adController.text.isEmpty || _soyadController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen Ad ve Soyad giriniz.")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      // 1. Auth ile Kullanıcı Oluştur (E-posta/Şifre)
      UserCredential userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Firestore'a Detayları Kaydet (Ad, Soyad, Can)
      await FirebaseFirestore.instance.collection('kullanicilar').doc(userCred.user!.uid).set({
        'ad': _adController.text.trim(),
        'soyad': _soyadController.text.trim(),
        'email': _emailController.text.trim(),
        'kalanCan': 3,       // Başlangıç hediyesi
        'yardimPuani': 0,    // Başlangıç puanı
        'toplamYildiz': 0,
        'degerlendirmeSayisi': 0,
        'kayitTarihi': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kayıt Başarılı! Hoş geldin.")));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AnaSayfa()));
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kayıt Hatası: ${e.message}")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.volunteer_activism, size: 60, color: Color(0xFF1A237E)),
                  const SizedBox(height: 10),
                  Text(
                    _isLoginMode ? "Giriş Yap" : "Aramıza Katıl",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                  ),
                  const SizedBox(height: 20),

                  // SADECE KAYIT MODUNDAYSA AD VE SOYAD GÖSTER
                  if (!_isLoginMode) ...[
                    Row(
                      children: [
                        Expanded(child: _customTextField(_adController, "Ad", Icons.person)),
                        const SizedBox(width: 10),
                        Expanded(child: _customTextField(_soyadController, "Soyad", Icons.person_outline)),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],

                  _customTextField(_emailController, "E-posta", Icons.email),
                  const SizedBox(height: 15),
                  _customTextField(_passwordController, "Şifre", Icons.lock, obscureText: true),

                  const SizedBox(height: 25),

                  // BUTON (Duruma göre değişir)
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : (_isLoginMode ? _girisYap : _kayitOl),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00BFA5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(_isLoginMode ? "GİRİŞ YAP" : "KAYIT OL", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // MOD DEĞİŞTİRME LİNKİ
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLoginMode = !_isLoginMode; // Modu tersine çevir
                      });
                    },
                    child: Text(
                      _isLoginMode ? "Hesabın yok mu? Kayıt Ol" : "Zaten hesabın var mı? Giriş Yap",
                      style: const TextStyle(color: Color(0xFF1A237E), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _customTextField(TextEditingController controller, String label, IconData icon, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
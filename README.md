# ❤️ CanCana: Dijital İmece ve Yardımlaşma Platformu

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%26%20Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)

> **"Sadece alan değil, veren el ol!"**

**CanCana**; öğrencilerin ihtiyaçlarını (ders notu, kitap, eşya vb.) karşılayabileceği, ancak bunu yaparken **oyunlaştırılmış (gamification)** bir yapıyla yardımlaşmaya teşvik edildiği, veritabanı destekli bir mobil uygulamadır.

---

## 📺 Proje Tanıtım Videosu
Projenin çalışır halini, ekranlarını ve veritabanı işlemlerini aşağıdaki videodan izleyebilirsiniz:

[![CanCana Tanıtım Videosu](https://img.youtube.com/vi/z0YwojCkASM/0.jpg)](https://www.youtube.com/watch?v=z0YwojCkASM)

*(Videoyu izlemek için yukarıdaki görsele tıklayınız)*

---

## 🚀 Projenin Amacı ve Senaryo

Bu proje, **Mobil Programlama Dersi Final Ödevi** kapsamında geliştirilmiştir. Temel amaç, öğrencilerin Flutter ve Firebase teknolojilerini kullanarak gerçek hayatta karşılığı olan bir problem çözmeleridir.

### ❓ Bu Uygulama Kimin İşine Yarar?
Bu uygulama;
* Kampüs içinde veya yurtta yaşayan,
* Ders notu, kitap veya çeşitli eşyalara ihtiyaç duyan,
* Elindeki kaynakları paylaşarak topluluğa katkı sağlamak isteyen,
* Güvenilir bir yardımlaşma ağı arayan
**lise ve üniversite öğrencileri** için geliştirilmiştir.

### ❓ Hangi Problemi Çözer?
Öğrenci topluluklarında sık yaşanan şu sorunlara çözüm getirir:
* **Dengesizlik:** Sürekli yardım isteyen ama hiç yardım etmeyen kullanıcı sorunu (Free-rider problemi).
* **Güvensizlik:** Yardımlaşma ağının düzensiz ve takipsiz olması.
* **İletişim Kopukluğu:** İhtiyaç sahibine ulaşmanın zorluğu.

**Çözüm:** CanCana, **"Can Sistemi"** ile çalışır. Bir kullanıcı yardım istediğinde **Can kaybeder**, başkasına yardım ettiğinde ise **Can ve Puan kazanır**. Bu döngü, sistemi sürekli canlı ve dengeli tutar.

### ❓ Nerede ve Nasıl Kullanılır?
Uygulama, mobil cihazlar üzerinden okulda, yurtta veya kampüste kolayca kullanılabilir.
**Kullanıcı:**
1.  İhtiyacı olduğunda bir talep açar (Bu işlem 1 Can harcar).
2.  Listelenen talepleri görür ve yardım etmek istediğine tıklar.
3.  **Canlı Sohbet** üzerinden detayları konuşur.
4.  Yardım tamamlandığında puan kazanır ve Liderlik Tablosunda yükselir.

---

## ✨ Öne Çıkan Özellikler

| Özellik | Açıklama |
|---|---|
| 🔐 **Güvenli Giriş** | Firebase Authentication ile E-posta/Şifre tabanlı güvenli kayıt ve giriş. |
| ❤️ **Can Sistemi** | Her kullanıcının 3 canı vardır. Yardım istedikçe azalır, yardım ettikçe artar. |
| 💬 **Canlı Sohbet** | Firestore Streams sayesinde yardım eden ve yardım isteyen arasında **Real-time (Gecikmesiz)** mesajlaşma. |
| 📊 **Liderlik Tablosu** | En çok yardım eden kullanıcıların sıralandığı rekabetçi alan. |
| 🔔 **Akıllı Bildirimler** | Yeni bir talep açıldığında veya yardım tamamlandığında anlık bildirimler. |
| 🔍 **Arama & Filtreleme** | Kategorilere (Kitap, Giyim, Yiyecek) göre filtreleme ve dinamik arama motoru. |
| 🎨 **Modern UI/UX** | Material Design 3 prensiplerine uygun, renk uyumlu ve kullanıcı dostu arayüz. |

---

## 🛠️ Kullanılan Teknolojiler ve Mimari

Bu projede **Modüler Mimari** kullanılmış ve kod temizliği (Clean Code) prensiplerine dikkat edilmiştir.

* **Framework:** Flutter (Dart)
* **Backend:** Google Firebase
    * **Authentication:** Kullanıcı yönetimi.
    * **Cloud Firestore:** NoSQL veritabanı (CRUD işlemleri).
* **Paketler:**
    * `firebase_core`, `firebase_auth`, `cloud_firestore`: Backend bağlantıları.
    * `flutter_local_notifications`: Yerel bildirim yönetimi.
    * `intl`: Tarih ve saat formatlama.

---

## ⚙️ Kurulum (Nasıl Çalıştırılır?)

Projeyi kendi bilgisayarınızda çalıştırmak için adımları takip edin:

1.  **Projeyi Klonlayın:**
    ```bash
    git clone [https://github.com/karabayraktarecrin-collab/cancana-mobil-uyg.git](https://github.com/karabayraktarecrin-collab/cancana-mobil-uyg.git)
    ```

2.  **Kütüphaneleri Yükleyin:**
    ```bash
    flutter pub get
    ```

3.  **Firebase Ayarları:**
    * Kendi Firebase projenizi oluşturun.
    * `google-services.json` dosyasını `android/app/` klasörüne ekleyin.

4.  **Çalıştırın:**
    ```bash
    flutter run
    ```

---

## 👤 Geliştirici

* **Ad Soyad:** Ecrin Karabayraktar
* **Ders:** Mobil Programlama Final Projesi

---

⭐ **Projeyi beğendiyseniz sağ üstten yıldız vermeyi unutmayın!**

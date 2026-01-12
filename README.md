# ❤️ CanCana: Dijital İmece ve Yardımlaşma Platformu

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Auth%20%26%20Firestore-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

> **"Sadece alan değil, veren el ol!"**

CanCana; öğrencilerin ihtiyaçlarını (ders notu, kitap, eşya vb.) karşılayabileceği, ancak bunu yaparken **oyunlaştırılmış (gamification)** bir yapıyla yardımlaşmaya teşvik edildiği, veritabanı destekli bir mobil uygulamadır.

---

## 📺 Proje Tanıtım Videosu
Projenin çalışır halini, ekranlarını ve veritabanı işlemlerini aşağıdaki videodan izleyebilirsiniz:

[![YouTube Video](https://www.youtube.com/watch?v=z0YwojCkASM)

*(Videoyu izlemek için yukarıdaki görsele tıklayınız)*

---

## 🚀 Projenin Amacı ve Senaryo
Bu proje, **Mobil Programlama Dersi Final Ödevi** kapsamında geliştirilmiştir. Temel amaç, öğrencilerin Flutter ve Firebase teknolojilerini kullanarak gerçek hayatta karşılığı olan bir problem çözmeleridir.

**Çözülen Problem:**
Öğrencilerin kampüs içinde yardımlaşma ağını kuramaması ve güvenilir bir takas/destek platformunun eksikliği.

**Çözüm:**
CanCana, **"Can Sistemi"** ile çalışır. Bir kullanıcı yardım istediğinde **Can kaybeder**, başkasına yardım ettiğinde ise **Can ve Puan kazanır**. Bu döngü, sistemi sürekli canlı ve dengeli tutar.

---

## ✨ Öne Çıkan Özellikler

| Özellik | Açıklama |
|---|---|
| 🔐 **Güvenli Giriş** | Firebase Authentication ile E-posta/Şifre tabanlı güvenli kayıt ve giriş. |
| ❤️ **Can Sistemi** | Her kullanıcının 3 canı vardır. Yardım istedikçe azalır, yardım ettikçe artır. |
| 💬 **Canlı Sohbet** | Firestore Streams sayesinde yardım eden ve yardım isteyen arasında **Real-time (Gecikmesiz)** mesajlaşma. |
| 📊 **Liderlik Tablosu** | En çok yardım eden kullanıcıların sıralandığı rekabetçi alan. |
| 🔔 **Akıllı Bildirimler** | Yeni bir talep açıldığında veya yardım tamamlandığında anlık bildirimler. |
| 🔍 **Arama & Filtreleme** | Kategorilere (Kitap, Giyim, Yiyecek) göre filtreleme ve dinamik arama motoru. |
| 🎨 **Modern UI/UX** | Material Design 3 prensiplerine uygun, renk uyumlu ve kullanıcı dostu arayüz. |

---

## 📱 Ekran Görüntüleri (Screenshots)

| Giriş Ekranı | Ana Sayfa | Sohbet Ekranı |
|:---:|:---:|:---:|
| <img src="assets/giris.png" width="200"/> | <img src="assets/ana_sayfa.png" width="200"/> | <img src="assets/chat.png" width="200"/> |

| Profil & Canlar | Talep Oluşturma | Liderlik Tablosu |
|:---:|:---:|:---:|
| <img src="assets/profil.png" width="200"/> | <img src="assets/talep.png" width="200"/> | <img src="assets/liderlik.png" width="200"/> |

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

* **Ad Soyad:** [Adın Soyadın]
* **GitHub:** [Profil Linkin]
* **Ders:** Mobil Programlama Final Projesi

---

⭐ **Projeyi beğendiyseniz sağ üstten yıldız vermeyi unutmayın!**

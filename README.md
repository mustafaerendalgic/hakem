# Hakem (İSG Takip ve Kural İhlali Yönetim Sistemi)

**Hakem**, endüstriyel sahalarda ve işletmelerde İş Sağlığı ve Güvenliği (İSG) süreçlerini dijitalleştirmek, kural ihlallerini kayıt altına almak ve kart cezası mantığıyla çalışan disiplin/aksiyon mekanizmasını sahaya entegre etmek amacıyla geliştirilmiş modern bir mobil uygulamadır.

Çevrimdışı öncelikli (*offline-first*) çalışma mimarisi ve kullanıcı dostu arayüzü ile sahadan hızlı veri girişine ve merkezi denetime olanak tanır.

---

## 📱 Ekran Görüntüleri

<div align="center">
  <img src="https://github.com/user-attachments/assets/eee913ac-114c-4d57-bb1c-4d78ba050c3f" width="30%" alt="Personel Listesi ve Arama" />
  <img src="https://github.com/user-attachments/assets/05cc808e-6b4e-441f-9ab1-2958e4846a7b" width="30%" alt="Kural İhlali Kayıt Ekranı" />
  <img src="https://github.com/user-attachments/assets/d4cbdff3-dbe1-4dc0-83cb-92304aa3449c" width="30%" alt="İhlal Bildirim Özeti / Detayı" />
</div>

---

## 🎯 Temel Özellikler

- **Personel Takibi & Arama:** Sahadaki personellerin sicil no, departman ve aktif ceza durumlarıyla birlikte anlık filtrelenmesi ve listelenmesi.
- **Kart/Ceza Puan Sistemi:** İSG ihlallerine göre sarı/kırmızı kart mantığıyla personelin ceza puanı ve geçmişinin dinamik yönetimi.
- **Detaylı İhlal Kaydı:**
  - İhlal türü (KKD eksikliği, tehlikeli davranış vb.) ve lokasyon/tarih seçimi.
  - Açıklama ve saha notu ekleme.
  - Fotoğraflı kanıt yükleme desteği.
- **Offline-First Yaklaşımı:** İnternet bağlantısının zayıf veya olmadığı saha ortamlarında verileri yerel veritabanında saklayıp bağlantı sağlandığında senkronize edebilme altyapısı.
- **İhlal Geçmişi & Arşivleme:** Geçmiş bildirimlerin detaylı dökümü, aksiyon takibi ve durum yönetimi.

---

## 🛠️ Teknoloji Yığını

- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **Mimari:** Clean Architecture / MVVM Pattern
- **Durum Yönetimi (State Management):** BLoC / Provider / Riverpod
- **Tasarım:** Figma UI/UX Tasarım Sistemi & Material 3

---

## 📂 Proje Yapısı

```text
lib/
├── core/             # Sabitler, temalar, hata yönetimi ve yardımcı araçlar
├── data/             # Veri modelleri, yerel/uzak veri kaynakları ve repository implementasyonları
├── domain/           # İş kuralları, use case'ler ve repository arayüzleri
└── presentation/     # UI katmanı (Ekranlar, widget bileşenleri ve state yönetimi)
    ├── screens/      # Personel listesi, ihlal formu, detay sayfaları
    └── widgets/      # Kartlar, özel butonlar, arama çubukları

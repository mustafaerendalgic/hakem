# Hakem

### İş sağlığı ve güvenliği (İSG) ihlallerini bildirmek, izlemek ve incelemek için geliştirilen mobil uygulama

[![Durum](https://img.shields.io/badge/durum-geli%C5%9Ftirme%20a%C5%9Famas%C4%B1nda-orange)](#proje-durumu) [![Flutter](https://img.shields.io/badge/Flutter-mobil%20uygulama-02569B?logo=flutter)](https://flutter.dev) [![Dart](https://img.shields.io/badge/Dart-3.12%2B-0175C2?logo=dart)](https://dart.dev) [![State Management](https://img.shields.io/badge/state-BLoC%2FCubit-purple)](https://bloclibrary.dev)

**Hakem**, saha ekiplerinin gördükleri **İSG (İş Sağlığı ve Güvenliği) ihlallerini** hızlıca bildirmesini; incelemeyle görevli kişilerin ise bu ihlalleri durumuna ve risk seviyesine göre takip edip sonuçlandırmasını sağlayan bir Flutter mobil uygulamasıdır.

> **Bu proje aktif geliştirme aşamasındadır.** Çimko bünyesindeki Flutter geliştirici stajı kapsamında geliştirilmektedir. Aşağıdaki bölümlerden [Mevcut Durum](#mevcut-durum) kod tabanında şu anda gerçekten var olanı, [Uygulama Mantığı](#uygulama-mantığı) ise hedeflenen tam işleyişi anlatır.

---

## Ekran Görüntüleri

Aşağıdaki görseller uygulamanın hedeflenen tasarımını gösteren Figma prototipleridir. Uygulamanın kod tarafındaki mevcut hâli bundan daha erken bir aşamadadır — bkz. [Mevcut Durum](#mevcut-durum).

<p align="center">
  <img src="https://github.com/user-attachments/assets/69249561-deb7-4b03-8eab-f7d61af99df6" width="260" alt="Hakem — giriş ekranı prototipi" />
  <img src="https://github.com/user-attachments/assets/44bc44ec-545a-417f-b06b-698ff9f8fc30" width="260" alt="Hakem — ana ekran prototipi" />
  <img src="https://github.com/user-attachments/assets/62722c61-73a0-4e90-ad39-2f19edfa320f" width="260" alt="Hakem — ek ekran prototipi" />
</p>

---

## Uygulama Mantığı

Uygulamanın hedeflenen davranışı, aşağıdaki modüler fonksiyonlar ve ekran bazlı akış algoritmaları üzerine kuruludur.

### Ortak Fonksiyonlar

**`F1_Ekrana_İhlal_Ekle(İhlal_Verisi)`**
Yeni bir ihlal paketi (görsel, konum, saat, risk tipi, açıklama) geldiğinde çalışır:
- Verinin bütünlüğü ve formatı doğrulanır.
- Geçerliyse kayıt Ana Ekran listesinin en üstüne eklenir ve okunmamış bildirim rozeti +1 artırılır.
- Geçersizse hata arka planda loglanır ve işlem sonlandırılır.

**`F2_Durum_Güncelle(İhlal_ID, Yeni_Durum)`**
Bir ihlalin durumu değiştirildiğinde çalışır:
- Sunucuya güncelleme isteği gönderilir.
- Başarılıysa: mobil hafızadaki kayıt güncellenir, ilgili kart anlık olarak yeni duruma göre yeniden çizilir, kullanıcıya başarı bildirimi (Toast/Snackbar) gösterilir.
- Başarısızsa: kullanıcıya ağ hatası uyarısı gösterilir ve ekran **önceki duruma geri alınır (rollback)**.

### 1. Ana Ekran (Home)

- Uygulama açıldığında sunucudan **"Yeni"** ve **"İnceleniyor"** durumundaki ilk 20 kayıt kronolojik sırayla istenir.
- Bağlantı başarısızsa "Bağlantı Kurulamadı" ekranı ve "Tekrar Deneyin" butonu gösterilir.
- Kayıt yoksa Empty State ("Henüz aktif bir ihlal kaydı bulunmamaktadır") gösterilir.
- Kayıtlar en yeni en üstte olacak şekilde listelenir (az önce reddedilen bir kayıt, ekrandan ayrılana kadar listede bir kez daha görünür).
- **Arka plan dinleyicisi:** sunucudan WebSocket/push ile yeni bir ihlal geldiğinde `F1_Ekrana_İhlal_Ekle` tetiklenir.
- **Kullanıcı etkileşimleri:**
  - *Sonsuz kaydırma:* listenin sonuna yaklaşınca sonraki 20 kayıt yüklenir.
  - *Arama / filtreleme:* metin veya risk filtresi girildiğinde liste anlık süzülür; sonuç yoksa uyarı gösterilir.
  - *Karta dokunma:* seçilen `İhlal_ID` ile **Detay Ekranı** açılır.
  - *Pull-to-refresh:* "Reddedildi" durumundaki kayıtlar listeden temizlenir, ilk 20 kayıt tazelenir.
  - *Kamera ile manuel bildirim:* fotoğraf çekilir → açıklama/konum/risk tipi formu doldurulur (zorunlu alan boşsa uyarı verilir) → "Gönder" ile veri sunucuya iletilir, `F1_Ekrana_İhlal_Ekle` çağrılır, Ana Ekran'a dönülür.
  - *Arşiv sekmesi:* alt bardan **Arşiv Ekranı**na geçilir.
  - *Bildirim simgesi:* okunmamış bildirimler listelenir, tıklanan bildirim okunmuş işaretlenir, rozet düşer, ilgili `İhlal_ID` ile **Detay Ekranı** açılır.

### 2. Detay Ekranı

- Seçilen `İhlal_ID`ye ait detaylar (büyük görsel, konum, zaman, açıklama) ekrana basılır.
- **Duruma göre dinamik buton yönetimi:**
  - `Yeni` → **[İncelemeye Al]** ve **[Reddet]** butonları
  - `İnceleniyor` → yalnızca **[Reddet]** butonu
  - `Reddedildi` → **[Yeniden Aç]** butonu
- **Aksiyonlar:**
  - *İncelemeye Al →* `F2_Durum_Güncelle(İhlal_ID, "İnceleniyor")`, başarılıysa butonlar güncellenir.
  - *Reddet →* onay pop-up'ı açılır; onaylanırsa `F2_Durum_Güncelle(İhlal_ID, "Reddedildi")` çalışır ve kayıt Ana Ekran akışından çıkarılır.
  - *Yeniden Aç (arşivden) →* `F2_Durum_Güncelle(İhlal_ID, "Yeni")` çalışır ve kayıt tekrar Ana Ekran akışına dahil olur.
- Geri butonuyla geldiği ekrana (Home, Bildirimler veya Arşiv) dönülür.

### 3. Arşiv Ekranı

- Sunucudan yalnızca **"Reddedildi"** durumundaki ilk 20 kayıt istenir.
- Kayıt yoksa Empty State ("Reddedilmiş veya arşivlenmiş ihlal bulunmamaktadır") gösterilir.
- Kayıtlar en yeniden en eskiye sıralanır.
- **Aksiyonlar:** sonsuz kaydırma, arama/filtreleme, karta tıklayınca **Detay Ekranı**na gitme.
- Geri butonuyla Ana Ekran'a dönülür.

---

## Mevcut Durum

Repoda şu anda uygulamanın mimari iskeleti ve temel UI bileşenleri bulunuyor; yukarıdaki algoritmaların büyük bölümü **henüz uygulanmadı**:

- **State management** — `flutter_bloc` ile her özellik için sealed state sınıfları (`ViolationStates`, `AuthenticationStates`); her ekran açık, kapsayıcı bir state kümesinden (loading / loaded / error) render ediliyor.
- **Repository pattern** — `HomeRepo` singleton'ı ihlal verisini Dart `Stream` olarak dışa açıyor; şu an mock/boş stream döndürüyor (`async* yield []`), gerçek backend (F1/F2 fonksiyonlarının çağıracağı sunucu) bağlandığında Cubit ve UI katmanına dokunmadan değiştirilebilecek şekilde tasarlandı.
- **Navigasyon** — `Session` singleton'ı (`ChangeNotifier`) bir `NavigationElement` enum'ı üzerinden uygulama genelinde sekme geçişini yönetiyor; bu sayede örneğin üst bardaki arşiv ikonuna basmak doğrudan Arşiv sekmesine atlayabiliyor.
- **Özel bottom navigation bar** — aktif sekmeyi "pill" arka planla vurgulayan elle yazılmış bir navigasyon çubuğu.
- **Yeniden kullanılabilir üst app bar** — `PreferredSizeWidget` implementasyonu, arşiv ve bildirimlere hızlı erişim ikonlarıyla.
- **Ortak bileşenler** — paylaşılan arama barı ve Lottie animasyonlu, "Tekrar Dene" callback'li boş durum (empty state) bileşeni (`SorryEmpty`), Home ve Arşiv ekranlarında ortak kullanılıyor.
- **Mock kimlik doğrulama** — e-posta/şifre ekranı `AuthenticationCubit` üzerinden uygulamanın geri kalanına erişimi kapatıyor; henüz arkasında gerçek bir backend yok.
- **Tasarım sistemi** — `AppColors` risk seviyesine göre bir renk skalası (Az Tehlikeli / Tehlikeli / Çok Tehlikeli / Min Risk) ve marka renklerini tanımlıyor; `TextStyles` Gabarito fontuna dayalı tipografi ölçeğini merkezileştiriyor.
- **Routing iskeleti** — Home, Arşiv, Fotoğraf, Analiz, Hesap ve Bildirimler tek bir `Scaffold` içinde enum tabanlı `switch` ile bağlanmış durumda; `Fotoğraf`, `Analiz`, `Hesap` ve `Bildirimler` şu an yer tutucu (placeholder) ekranlar.

**Henüz yapılmayanlar** (yukarıdaki algoritmalarda tarif edilen ama kodda karşılığı olmayanlar):
- Gerçek backend / sunucu bağlantısı (F1, F2 fonksiyonları, WebSocket/push dinleyicisi)
- Sayfalama / sonsuz kaydırma (infinite scroll)
- Arama ve risk filtresi ile anlık süzme
- Pull-to-refresh
- Kamera ile ihlal bildirimi ve form akışı
- Detay Ekranı ve duruma göre dinamik buton mantığı (İncelemeye Al / Reddet / Yeniden Aç, rollback davranışı)
- Bildirim listesi ve okundu işaretleme
- Analiz dashboard'u, hesap yönetimi

---

## Proje Yapısı

```
lib/
├── data/
│   ├── cubits/          # AuthenticationCubit, ViolationCubit
│   ├── entity/           # Violation modeli
│   ├── repo/              # HomeRepo — veri kaynağı soyutlaması (Stream tabanlı)
│   ├── session/          # Session singleton + NavigationElement enum
│   └── states/            # Her Cubit için sealed state sınıfları
├── theme/
│   ├── app_colors.dart   # Risk seviyesine dayalı renk sistemi
│   └── text_styles.dart  # Merkezi tipografi
├── ui/
│   ├── account/
│   ├── analysis/
│   ├── archives/
│   ├── authentication/
│   ├── common/            # SearchBarSection, SorryEmpty, TopAppBar
│   ├── home/
│   ├── notifications/
│   └── photo/
└── main.dart
```

---

## Teknoloji Yığını

### Şu An Kullanılan
- **Flutter** — çapraz platform uygulama framework'ü
- **Dart** — birincil programlama dili
- **flutter_bloc (Cubit)** — sealed state sınıflarıyla state management
- **Dart Streams** — repository ile Cubit katmanı arasında real-time'a hazır veri akışı
- **Lottie** — boş durum animasyonları
- **Özel font** — Gabarito

### Planlanan Entegrasyonlar
- Mock repository stream'lerinin yerini alacak gerçek bir backend (Firebase veya REST API)
- Saha bildirimi için kamera erişimi
- WebSocket/push notification tabanlı arka plan dinleyicisi
- Analiz dashboard'u için grafik/analitik kütüphanesi
- Push bildirimleri

---

## Başlarken

### Gereksinimler
- Flutter SDK
- `^3.12.2` ile uyumlu Dart SDK
- Android Studio veya Visual Studio Code
- Android SDK/emülatör ya da fiziksel cihaz
- macOS'ta iOS geliştirmesi için Xcode

### Kurulum

```
git clone https://github.com/mustafaerendalgic/hakem.git
cd hakem
flutter pub get
flutter run
```

---

## Proje Durumu

Hakem, Çimko bünyesindeki Flutter geliştirici stajı kapsamında geliştirilen, erken aşamada ve aktif olarak geliştirilmeye devam eden bir projedir. Şu anki odak, [Uygulama Mantığı](#uygulama-mantığı) bölümünde tarif edilen akışları (gerçek backend, kamera ile bildirim, detay ekranı, arşiv/filtreleme) sırayla hayata geçirmek.

Proje hâlâ geliştiği için:
- Veri katmanı, gerçek backend entegre edildiğinde değişecek.
- Ekranlar Figma prototiplerine uyacak şekilde yeniden tasarlanabilir.
- Klasör yapısı yeni özellikler eklendikçe yeniden düzenlenebilir.

---

## Yol Haritası

- [x] Proje iskeleti ve navigasyon yapısı
- [x] Sealed state'lerle Cubit/BLoC mimarisi
- [x] İhlal verisi için repository soyutlaması (Stream tabanlı)
- [x] Özel bottom navigation ve top app bar
- [x] Mock kimlik doğrulama akışı
- [x] Boş durum (empty state) yönetimiyle Home ve Arşiv ekranları
- [ ] Gerçek backend entegrasyonu (F1/F2 fonksiyonları)
- [ ] Arka plan dinleyicisi (WebSocket / push notification)
- [ ] Kamera ile ihlal bildirimi formu
- [ ] Sonsuz kaydırma (infinite scroll) ve sayfalama
- [ ] Arama ve risk filtresiyle anlık süzme
- [ ] Pull-to-refresh
- [ ] Detay Ekranı ve durum bazlı buton mantığı (İncelemeye Al / Reddet / Yeniden Aç)
- [ ] Bildirim listesi ve okundu işaretleme
- [ ] Analiz dashboard'u
- [ ] Hesap yönetimi ekranı
- [ ] Otomatik testler

---

## Geliştirici

[Mustafa Eren Dalgıç](https://github.com/mustafaerendalgic) tarafından geliştirilmektedir.

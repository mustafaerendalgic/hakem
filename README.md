# Hakem

### İş sağlığı ve güvenliği ihlallerini sahadan bildirmek, gerçek zamanlı takip etmek ve sonuçlandırmak için geliştirilen mobil uygulama

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.12%2B-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Supabase](https://img.shields.io/badge/Supabase-3FCF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![State Management](https://img.shields.io/badge/State-Cubit%20%2F%20BLoC-7B1FA2)](https://bloclibrary.dev)
[![Durum](https://img.shields.io/badge/Durum-Geliştirme%20aşamasında-orange)](#proje-durumu)

**Hakem**, sahada tespit edilen İSG ihlallerinin fotoğraf ve konum bilgisiyle kayıt altına alınmasını; yetkili kullanıcıların bu kayıtları incelemesini, durumlarını güncellemesini, arşivlemesini ve toplu verileri analiz etmesini sağlayan Flutter tabanlı bir mobil uygulamadır.

Proje, **Çimko bünyesindeki Flutter geliştirici stajı** kapsamında geliştirilmiştir ve aktif geliştirme aşamasındadır.

## Ekran Görüntüleri

### Tasarım prototipleri

<p align="center">
  <img src="https://github.com/user-attachments/assets/69249561-deb7-4b03-8eab-f7d61af99df6" width="260" alt="Hakem giriş ekranı tasarım prototipi" />
  <img src="https://github.com/user-attachments/assets/44bc44ec-545a-417f-b06b-698ff9f8fc30" width="260" alt="Hakem ana ekran tasarım prototipi" />
  <img src="https://github.com/user-attachments/assets/62722c61-73a0-4e90-ad39-2f19edfa320f" width="260" alt="Hakem ekran tasarım prototipi" />
</p>

### Uygulamadan güncel görüntüler

<p align="center">
  <img src="https://github.com/user-attachments/assets/a61cea71-aa8e-4007-9231-ec216c257055" width="220" alt="Hakem mobil uygulama ekranı 1" />
  <img src="https://github.com/user-attachments/assets/3fa96db9-4ac3-4654-a921-da66965d3dd8" width="220" alt="Hakem mobil uygulama ekranı 2" />
  <img src="https://github.com/user-attachments/assets/1ee1727f-9225-4a2d-838c-228708f8609f" width="220" alt="Hakem mobil uygulama ekranı 3" />
  <img src="https://github.com/user-attachments/assets/691c93f6-98d8-4abe-a0d0-e2acbe89fedf" width="220" alt="Hakem mobil uygulama ekranı 4" />
</p>

## Temel Özellikler

- **Kimlik doğrulama:** Firebase Authentication ile e-posta/şifre tabanlı kayıt, oturum açma ve çıkış yapma
- **Gerçek zamanlı ihlal akışı:** Cloud Firestore snapshot stream’leri üzerinden kayıtların anlık güncellenmesi
- **Kamera ile bildirim:** Uygulama içinden fotoğraf çekme, ihlal bilgilerini form üzerinden tamamlama ve görseli Firebase Storage’a yükleme
- **Katalog tabanlı form:** Supabase üzerinden ihlal türleri, kategoriler, tesis bölgeleri ve lokasyonların alınması
- **İhlal yaşam döngüsü:** Kayıtları `Yeni`, `İnceleniyor`, `Çözümlendi` ve `Reddedildi` durumları arasında yönetme
- **Detay ekranı:** Görsel, açıklama, lokasyon, tarih ve işlem bilgilerinin görüntülenmesi
- **Arşiv:** Reddedilen kayıtların ayrı bir Firestore koleksiyonunda gerçek zamanlı listelenmesi ve yeniden açılabilmesi
- **Bildirim merkezi:** Kullanıcı bazlı görülme bilgisinin tutulması ve okunmamış kayıt sayısının hesaplanması
- **Analiz ekranı:** Supabase RPC üzerinden toplam ihlal, aylık kayıt, çözüm oranı, lokasyon ve ihlal türü metriklerinin alınması
- **Merkezi durum yönetimi:** Her özellik için Cubit, sealed state ve repository katmanları

## Uygulama Akışı

1. Kullanıcı Firebase Authentication üzerinden giriş yapar.
2. Ana ekranda Firestore’daki ihlaller gerçek zamanlı olarak listelenir.
3. Kamera sekmesinden fotoğraf çekilir; açıklama, lokasyon ve ihlal türü seçilerek kayıt oluşturulur.
4. Fotoğraf Firebase Storage’a, ihlal verisi Cloud Firestore’a yüklenir.
5. Yetkili kullanıcı detay ekranından kaydı incelemeye alabilir, çözebilir, reddedebilir veya yeniden açabilir.
6. Reddedilen kayıtlar arşiv ekranına taşınır; durum değişiklikleri açık olan ekranlara anlık yansır.
7. Analiz ekranı, Supabase üzerindeki toplulaştırılmış metrikleri filtrelere göre sunar.

## Mimari

Uygulama, kullanıcı arayüzünü veri kaynaklarından ayıran özellik odaklı bir **Cubit + Repository** yapısı kullanır.

```text
UI / Screens
    ↓ kullanıcı işlemleri ve state render
Cubits + Sealed States
    ↓ iş akışı yönetimi
Repositories
    ├── Firebase Auth       → kullanıcı oturumu
    ├── Cloud Firestore     → ihlaller, arşiv ve görülme bilgisi
    ├── Firebase Storage    → ihlal fotoğrafları
    └── Supabase REST / RPC → referans katalogları ve analiz verileri
```

`NavigationSession`, ana sekmeler ile detay ekranı arasındaki geçişleri merkezi olarak yönetir. Firestore kullanan repository’ler veriyi `Stream` olarak Cubit’lere aktarır. Böylece Home, Arşiv, Bildirimler ve Detay ekranları backend değişikliklerine gerçek zamanlı tepki verir.

## Proje Yapısı

```text
lib/
├── data/
│   ├── cubits/          # Ekran ve özellik bazlı Cubit'ler
│   ├── entity/          # Violation ve analiz modelleri
│   ├── repo/            # Firebase, kamera, form, analiz ve katalog erişimi
│   │   └── catalog/     # Supabase referans veri katmanı
│   ├── session/         # Navigasyon oturumu ve sabitler
│   └── states/          # Cubit state sınıfları
├── theme/               # Renk ve tipografi sistemi
├── ui/
│   ├── account/         # Hesap ve çıkış
│   ├── analysis/        # Analiz paneli
│   ├── archives/        # Reddedilen ihlaller
│   ├── authentication/  # Giriş ve kayıt
│   ├── common/          # Ortak kart, üst bar, arama ve etiket bileşenleri
│   ├── detail/          # İhlal detay ve aksiyonları
│   ├── home/            # Gerçek zamanlı ihlal listesi
│   ├── notifications/   # Görülme durumuna dayalı bildirimler
│   └── photo/           # Kamera, önizleme ve ihlal formu
├── firebase_options.dart
└── main.dart
```

## Teknoloji Yığını

| Alan | Teknoloji |
| --- | --- |
| Mobil uygulama | Flutter, Dart |
| State management | `flutter_bloc` / Cubit |
| Kimlik doğrulama | Firebase Authentication |
| Operasyonel veri | Cloud Firestore |
| Görsel depolama | Firebase Storage |
| Referans ve analiz verisi | Supabase REST API ve RPC |
| Kamera | `camera` |
| Ağ istekleri | `http` |
| Reaktif veri işleme | Dart Streams, `rxdart` |
| Görsel önbellekleme | `cached_network_image` |
| Yerelleştirme | `intl` (`tr_TR`) |
| Ortam değişkenleri | `flutter_dotenv` |

## Kurulum

### Gereksinimler

- Flutter SDK ve Dart `^3.12.2`
- Android Studio veya Visual Studio Code
- Android SDK/emülatör ya da fiziksel Android cihaz
- iOS geliştirmesi için macOS ve Xcode
- Yapılandırılmış bir Firebase projesi
- Gerekli tabloları ve `get_violation_analytics` RPC fonksiyonunu içeren bir Supabase projesi

### 1. Repoyu klonlayın

```bash
git clone https://github.com/mustafaerendalgic/hakem.git
cd hakem
flutter pub get
```

### 2. Ortam değişkenlerini ekleyin

Proje kökünde bir `.env` dosyası oluşturun:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

> `.env` dosyanızı ve gerçek servis anahtarlarınızı sürüm kontrolüne eklemeyin.

### 3. Firebase’i yapılandırın

Kendi Firebase projeniz için FlutterFire CLI kullanarak platform dosyalarını üretin:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Firebase Console’da Authentication, Cloud Firestore ve Storage servislerini etkinleştirin. Android ve iOS için gerekli platform yapılandırma dosyalarının oluşturulduğunu doğrulayın.

### 4. Uygulamayı çalıştırın

```bash
flutter run
```

Kamera akışını test ederken emülatör yerine fiziksel cihaz kullanılması önerilir.

## Veri Modeli

Bir ihlal kaydı temel olarak aşağıdaki alanları taşır:

- Kayıt kimliği ve fotoğraf URL’si
- Açıklama, lokasyon ve oluşturulma tarihi
- Kaydı oluşturan kullanıcının UID’si
- Katalogdan seçilen ihlal türü
- Güncel aksiyon durumu
- İşlemi yapan kişi ve işlem zamanı
- Kaydı görüntüleyen kullanıcıların UID listesi

Desteklenen durumlar:

| Durum | Açıklama |
| --- | --- |
| `posted` | Yeni oluşturulan ihlal |
| `investigating` | İnceleme altındaki ihlal |
| `resolved` | Çözümlenmiş ihlal |
| `rejected` | Reddedilmiş ve arşivlenmiş ihlal |

## Proje Durumu

Uygulamanın kimlik doğrulama, gerçek zamanlı listeleme, kamera, form, görsel yükleme, detay aksiyonları, arşiv, bildirim görülme takibi ve analiz veri akışları kod tabanında bulunmaktadır.

Proje henüz üretim sürümü değildir. Bazı ekranlar ve akışlar geliştirme ve doğrulama aşamasındadır.

### Bilinen geliştirme alanları

- Form doğrulamalarının ve kullanıcıya gösterilen hata mesajlarının tamamlanması
- Arama ve filtre kontrollerinin veri sorgularına bağlanması
- Sayfalama, pull-to-refresh ve büyük veri kümeleri için sorgu optimizasyonu
- Firebase ile Supabase arasındaki veri sorumluluklarının netleştirilmesi
- Ortam ve servis yapılandırmalarının örnek dosyalarla belgelenmesi
- Firestore ve Storage güvenlik kurallarının üretim gereksinimlerine göre sıkılaştırılması
- Otomatik birim, widget ve entegrasyon testlerinin eklenmesi
- CI/CD, statik analiz ve release süreçlerinin kurulması
- Hesap ekranının profil yönetimiyle genişletilmesi

## Yol Haritası

- [x] Flutter proje iskeleti ve tasarım sistemi
- [x] Cubit/BLoC tabanlı state yönetimi
- [x] Firebase Authentication entegrasyonu
- [x] Firestore ile gerçek zamanlı ihlal akışı
- [x] Kamera ve fotoğraf önizleme akışı
- [x] Firebase Storage’a görsel yükleme
- [x] İhlal oluşturma formu ve Supabase katalogları
- [x] Detay ekranında durum güncelleme aksiyonları
- [x] Arşiv ve yeniden açma akışı
- [x] Kullanıcı bazlı görülme/bildirim takibi
- [x] Supabase RPC tabanlı analiz özeti
- [ ] Arama, filtreleme ve sayfalama
- [ ] Kapsamlı hata yönetimi ve form doğrulama
- [ ] Otomatik testler
- [ ] CI/CD ve üretim dağıtım süreci

## Katkı

Proje aktif geliştirme aşamasındadır. Hata bildirimi veya geliştirme önerisi için issue açabilir; değişiklik önerilerinizi ayrı bir branch üzerinden pull request olarak gönderebilirsiniz.

## Geliştirici

[Mustafa Eren Dalgıç](https://github.com/mustafaerendalgic) tarafından geliştirilmektedir.

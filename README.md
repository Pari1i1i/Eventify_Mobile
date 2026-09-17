# Eventify Mobile

Aplikasi mobile **Eventify** untuk pembelian tiket, manajemen acara, dan scan QR check-in saat masuk venue.

Dibangun dengan **Flutter** menggunakan pola **Feature-First** + **Riverpod** untuk state management.

## Tech Stack

- **Flutter** (SDK `>=3.5.0`)
- **Riverpod** — state management
- **Dio** — HTTP client
- **go_router** — routing
- **mobile_scanner** — scan QR code (check-in)
- **qr_flutter** — generate QR code tiket
- **flutter_secure_storage** — simpan JWT token dengan aman
- **shared_preferences** — cache & base URL custom
- **google_fonts** — font Space Grotesk / Plus Jakarta Sans
- **cached_network_image** — cache gambar poster event
- **google_sign_in** — opsi login Google

## Fitur

| Area       | Fitur                                                             |
| ---------- | ----------------------------------------------------------------- |
| Auth       | Login, register, logout, ganti password, login Google              |
| Acara      | List event, detail event, poster & lokasi                          |
| Pemesanan  | Checkout tiket, riwayat order, halaman pembayaran                  |
| Tiket      | Daftar tiket saya, detail tiket, tampilan QR tiket                 |
| Organizer  | Dashboard organizer, CRUD event, kelola ticket tiers, upload banner|
| Scanner    | Scan QR tiket peserta, validasi & check-in                         |

## Struktur Proyek

```
lib/
├── core/
│   ├── constants/     # ApiConstants (base URL, endpoint)
│   ├── network/       # Dio client, interceptor token
│   ├── router/        # go_router setup
│   ├── storage/       # secure storage & shared preferences
│   ├── utils/
│   └── widgets/
├── features/
│   ├── auth/          # login, register, profile
│   ├── events/        # list & detail event
│   ├── orders/        # checkout, order, pembayaran
│   ├── organizer/     # dashboard & CRUD event panitia
│   ├── scanner/       # QR check-in
│   └── tickets/       # my tickets & detail tiket
└── user/              # komponen & data user
```

Setiap fitur mengikuti struktur: `models/`, `providers/`, `screens/`, `services/`, `widgets/`.

## Menjalankan Secara Lokal

1. **Prasyarat**: Flutter SDK terpasang (sesuai `pubspec.yaml`), Android Studio / emulator / device.

2. **Install dependensi**:

   ```bash
   flutter pub get
   ```

3. **Konfigurasi API**:

   Edit `lib/core/constants/api_constants.dart`:

   ```dart
   static const String defaultBaseUrl = 'https://photographic-more-clearly-essays.trycloudflare.com/api/v1';
   ```

   Aplikasi juga menyimpan base URL custom di `SharedPreferences` (key `eventify_custom_base_url`) — bisa diubah dari pengaturan aplikasi tanpa rebuild.

4. **Jalankan aplikasi**:

   ```bash
   flutter run
   ```

   Untuk Android: `flutter run -d emulator-5554` atau pilih perangkat dari `flutter devices`.

5. **Build APK release**:

   ```bash
   flutter build apk --release
   ```

   Hasil: `build/app/outputs/flutter-apk/app-release.apk`.

## Endpoint Utama yang Dipakai

Endpoint didefinisikan di `api_constants.dart`:

| Area       | Endpoint                                     |
| ---------- | -------------------------------------------- |
| Auth       | `/auth/login`, `/auth/register`, `/auth/me`  |
| Events     | `/events`, `/events/:slug`                   |
| Orders     | `/orders`, `/orders/my-orders`               |
| Tickets    | `/tickets/my-tickets`, `/tickets/:code`      |
| Organizer  | `/organizer/my-events`, `/organizer/events`  |
| Scanner    | `/scanner/check-in`                          |

## Lisensi

MIT
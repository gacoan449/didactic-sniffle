# Pengaturan Hak Akses Admin (Custom Claims)

Untuk menjadikan akun sebagai Admin yang aman, gunakan Firebase CLI:

```bash
# Login ke Firebase
firebase login

# Set hak admin ke UID tertentu
firebase auth:update <UID_ADMIN> --custom-claims '{"admin": true}'

# Cek apakah sudah terpasang
firebase auth:print <UID_ADMIN>
git add .
git commit -m "Perbaikan Akhir Security Rules & Panduan Admin"
cd ~/PetaniDesaBerkah

# ==================================================
# 1. PERBAIKAN PUBspec.yaml: EDIT BAGIAN YANG SUDAH ADA, TIDAK TUMPANG TINDIH
# ==================================================
echo "🔧 Memperbaiki pubspec.yaml dengan struktur benar..."
cat > pubspec.yaml << 'EOF'
name: petani_desa_berkah
description: Aplikasi E-Commerce Hasil Tani Petani Desa Berkah
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

  # Firebase Inti
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.1
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.6.0

  # Keamanan & Utilitas
  crypto: ^3.0.3
  convert: ^3.1.1
  encrypt: ^5.0.3
  pointycastle: ^3.7.3
  intl: ^0.18.1
  image_picker: ^1.0.7
  path_provider: ^2.1.1
  shared_preferences: ^2.2.2
  connectivity_plus: ^5.0.2
  device_info_plus: ^9.1.2
  http: ^1.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.3
  # Pengujian Tambahan
  mockito: ^5.4.4
  firebase_auth_mocks: ^0.13.0
  fake_cloud_firestore: ^2.4.9
  integration_test:
    sdk: flutter
  lcov: ^1.0.1

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/

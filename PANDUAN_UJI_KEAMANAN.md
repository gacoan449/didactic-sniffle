# 🧪 PENGUJIAN ATURAN KEAMANAN DENGAN FIREBASE EMULATOR

## 1. Pasang Firebase Emulator
```bash
firebase init emulators
firebase emulators:start --only firestore,storage,auth
const { initializeTestEnvironment } = require("@firebase/rules-unit-testing");
const fs = require("fs");

const aturan = fs.readFileSync("firestore.rules", "utf8");

describe("Aturan Keamanan", () => {
  let env;
  beforeAll(async () => {
    env = await initializeTestEnvironment({ firestore: { rules: aturan } });
  });

  test("Pembeli tidak bisa ubah produk orang lain", async () => {
    const db = env.authenticatedContext("UID_PEMBELI").firestore();
    await expect(db.collection("produk").doc("P1").set({nama: "Palsu"})).toBeDenied();
  });

  test("Penjual bisa ubah produk tokonya sendiri", async () => {
    const db = env.authenticatedContext("UID_PENJUAL").firestore();
    await env.withSecurityRulesDisabled(ctx => ctx.firestore().collection("toko").doc("T1").set({idPemilik: "UID_PENJUAL"}));
    await expect(db.collection("produk").doc("P1").set({idToko:"T1"})).toBeAllowed();
  });
});
firebase emulators:exec --only firestore 'npm test'
npm install -g firebase-tools
firebase login
firebase use petani-desa-berkah

# Deploy aturan & indeks
firebase deploy --only firestore:rules,firestore:indexes,storage:rules
./jalankan_uji.sh

flutter build appbundle --release
flutter build web --release
cd ~/PetaniDesaBerkah

# ==================================================
# 1. TAMBAH SEMUA PAKET YANG DIBUTUHKAN
# ==================================================
echo "🔧 Menambahkan paket pendukung semua fitur..."
cat > pubspec.yaml << 'EOF'
name: petani_desa_berkah
description: E-Commerce Pertanian Terpadu Petani Desa Berkah
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
  firebase_messaging: ^14.7.10
  firebase_app_check: ^0.2.1+8
  cloud_functions: ^4.6.5

  # Keamanan
  crypto: ^3.0.3
  convert: ^3.1.1
  encrypt: ^5.0.3
  local_auth: ^2.1.7
  flutter_security: ^2.0.0
  jose: ^0.3.4

  # Fitur Umum
  intl: ^0.18.1
  image_picker: ^1.0.7
  image_cropper: ^5.0.1
  path_provider: ^2.1.1
  shared_preferences: ^2.2.2
  connectivity_plus: ^5.0.2
  device_info_plus: ^9.1.2
  url_launcher: ^6.2.2
  printing: ^5.11.1
  pdf: ^3.10.7
  excel: ^2.1.0

  # Lokasi & Peta
  geolocator: ^10.1.0
  google_maps_flutter: ^2.5.3
  geocoding: ^2.1.1

  # Pembayaran
  http: ^1.1.0
  midtrans_sdk: ^0.4.0
  flutter_xendit: ^0.0.7

  # Chat & Media
  file_picker: ^6.1.1
  record: ^5.0.4
  just_audio: ^0.9.36
  flutter_image_zoom: ^1.0.0
  video_player: ^2.8.2
  chewie: ^1.7.1

  # QR & Barcode
  mobile_scanner: ^3.5.5
  qr_flutter: ^4.1.0

  # Lainnya
  syncfusion_flutter_charts: ^24.1.45
  syncfusion_flutter_pdf: ^24.1.45
  syncfusion_flutter_xlsio: ^24.1.45
  flutter_local_notifications: ^16.3.2
  timezone: ^0.9.2
  signature: ^5.4.0
  pinput: ^3.0.1
  flutter_svg: ^2.0.9
  cached_network_image: ^3.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.3
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
    - assets/laporan/

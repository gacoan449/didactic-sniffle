#!/bin/bash
warna_hijau="\033[1;32m"
warna_merah="\033[1;31m"
warna_biru="\033[1;34m"
reset="\033[0m"

echo -e "${warna_biru}=================================================="
echo "📋 PEMERIKSAAN LENGKAPAN FITUR PETANI DESA BERKAH"
echo "==================================================${reset}"

total=0
sudah=0
kurang=0

cek_fitur() {
  nama="$1"
  pola="$2"
  ((total++))

  if grep -rq "$pola" lib/ --include="*.dart" --include="*.yaml" --include="*.rules"; then
    echo -e "✅ ${warna_hijau}ADA${reset}  : $nama"
    ((sudah++))
  else
    echo -e "❌ ${warna_merah}KURANG${reset}: $nama"
    ((kurang++))
  fi
}

# ==================================================
# KELOMPOK 1: AKUN PEMBELI
# ==================================================
echo -e "\n${warna_biru}--- 1. AKUN PEMBELI ---${reset}"
cek_fitur "Registrasi & Login" "firebase_auth\|login\|register"
cek_fitur "Login Google" "GoogleSignIn\|signInWithGoogle"
cek_fitur "Login HP OTP" "PhoneAuth\|verifyPhoneNumber"
cek_fitur "Lupa Password" "sendPasswordResetEmail"
cek_fitur "Edit Profil & Foto" "uploadFotoProfil\|updateProfil"
cek_fitur "Alamat Pengiriman Banyak" "alamatPengiriman\|daftarAlamat"
cek_fitur "Wishlist & Favorit" "wishlist\|favorit"
cek_fitur "Voucher Saya" "voucherPengguna\|daftarVoucher"
cek_fitur "Riwayat Aktivitas" "logAktivitas"

# ==================================================
# KELOMPOK 2: PRODUK
# ==================================================
echo -e "\n${warna_biru}--- 2. PRODUK ---${reset}"
cek_fitur "Foto & Video Produk" "daftarGambar\|videoProduk"
cek_fitur "Zoom & Spesifikasi" "zoom\|spesifikasi"
cek_fitur "Variasi & Berat" "variasi\|berat"
cek_fitur "Produk Organik" "organik"
cek_fitur "Promo & Flash Sale" "promo\|flashSale"
cek_fitur "Rekomendasi & Serupa" "produkRekomendasi\|produkSerupa"
cek_fitur "Rating & Ulasan" "rating\|ulasan"
cek_fitur "Tanya Jawab Produk" "tanyaJawab"

# ==================================================
# KELOMPOK 3: TOKO & SUPPLIER
# ==================================================
echo -e "\n${warna_biru}--- 3. TOKO & SUPPLIER ---${reset}"
cek_fitur "Verifikasi Dokumen" "verifikasiKTP\|verifikasiRekening"
cek_fitur "Lokasi & Jadwal Panen" "lokasiGPS\|jadwalPanen"
cek_fitur "Statistik & Saldo" "statistikPenjualan\|saldoSupplier"
cek_fitur "Pencairan Dana" "riwayatPencairan"
cek_fitur "Chat Pembeli & Admin" "chatPembeli\|chatAdmin"

# ==================================================
# KELOMPOK 4: KASIR TOKO
# ==================================================
echo -e "\n${warna_biru}--- 4. KASIR TOKO ---${reset}"
cek_fitur "Scan Barcode/QR" "mobile_scanner\|scanBarcode"
cek_fitur "Buka Tutup Kas" "StatusKas\|bukaKas\|tutupKas"
cek_fitur "Laporan Kas Harian" "laporanKas\|daftarIdTransaksi"
cek_fitur "Refund & Retur" "refund\|retur"
cek_fitur "Cetak Struk" "printing\|cetakStruk"

# ==================================================
# KELOMPOK 5-7: KERANJANG, CHECKOUT, PEMBAYARAN
# ==================================================
echo -e "\n${warna_biru}--- 5-7. KERANJANG & PEMBAYARAN ---${reset}"
cek_fitur "Keranjang Lengkap" "keranjang\|simpanNanti\|catatanPembeli"
cek_fitur "Kurir & Ongkir Otomatis" "kurir\|ongkir\|asuransi"
cek_fitur "Metode Pembayaran Lengkap" "METODE_\|midtrans\|xendit\|QRIS"

# ==================================================
# KELOMPOK 8: DOMPET DIGITAL
# ==================================================
echo -e "\n${warna_biru}--- 8. DOMPET DIGITAL ---${reset}"
cek_fitur "Saldo Terpisah" "saldoTersedia\|saldoDitahan\|saldoPending"
cek_fitur "Mutasi & Keamanan" "Mutasi\|pinHash\|local_auth"

# ==================================================
# KELOMPOK 9: KREDIT
# ==================================================
echo -e "\n${warna_biru}--- 9. KREDIT ---${reset}"
cek_fitur "Struktur Kredit Terpisah" "PengajuanKredit\|KontrakKredit\|Tagihan\|PembayaranAngsuran"
cek_fitur "Verifikasi Dokumen" "uploadKTP\|uploadKK\|selfie"

# ==================================================
# KELOMPOK 10-11: SOPIR & KURIR
# ==================================================
echo -e "\n${warna_biru}--- 10-11. SOPIR & KURIR ---${reset}"
cek_fitur "Data Mitra & Kendaraan" "Mitra\|Kendaraan\|SIM\|STNK"
cek_fitur "GPS & Tracking" "geolocator\|lokasiMitra\|liveLocation"
cek_fitur "Checklist & Bukti" "checklist\|buktiFoto\|tandaTangan"
cek_fitur "Poin & Insentif" "poinPelanggaran\|insentif"

# ==================================================
# KELOMPOK 12: GUDANG
# ==================================================
echo -e "\n${warna_biru}--- 12. GUDANG ---${reset}"
cek_fitur "Barang Masuk/Keluar" "BarangMasuk\|BarangKeluar"
cek_fitur "Stok Batch & FIFO" "StokBatch\|FIFO\|kadaluarsa"
cek_fitur "Lokasi Rak & Audit" "lokasiRak\|auditStok"

# ==================================================
# KELOMPOK 13-14: ADMIN & OWNER
# ==================================================
echo -e "\n${warna_biru}--- 13-14. ADMIN & OWNER ---${reset}"
cek_fitur "Kelola Semua Peran" "PERAN_\|blokirAkun"
cek_fitur "Promo & Voucher" "kelolaPromo\|kelolaVoucher"
cek_fitur "Dashboard & Statistik" "dashboard\|statistikNasional"
cek_fitur "Backup & Restore" "backup\|restore"

# ==================================================
# KELOMPOK 15-17: CHAT, NOTIF, PETA
# ==================================================
echo -e "\n${warna_biru}--- 15-17. CHAT, NOTIF, PETA ---${reset}"
cek_fitur "Chat Lengkap" "RuangChat\|Pesan\|terkirim\|dibaca\|typing"
cek_fitur "Notifikasi" "firebase_messaging\|notifikasi"
cek_fitur "Peta & Rute" "google_maps\|estimasiWaktu"

# ==================================================
# KELOMPOK 18-19: AI & KEAMANAN
# ==================================================
echo -e "\n${warna_biru}--- 18-19. AI & KEAMANAN ---${reset}"
cek_fitur "Fitur AI" "prediksi\|deteksiPenipuan\|rekomendasi"
cek_fitur "Keamanan Lengkap" "AppCheck\|Enkripsi\|AntiRoot\|AuditLog"

# ==================================================
# KELOMPOK 20: LAPORAN
# ==================================================
echo -e "\n${warna_biru}--- 20. LAPORAN ---${reset}"
cek_fitur "Semua Jenis Laporan" "Laporan\|LabaRugi\|ArusKas\|Pajak"
cek_fitur "Export PDF & Excel" "pdf\|excel\|printing"

# ==================================================
# RANGKUMAN AKHIR
# ==================================================
echo -e "\n${warna_biru}=================================================="
echo "📊 RANGKUMAN HASIL PEMERIKSAAN"
echo "=================================================="
echo -e "Total Fitur Diperiksa : $total"
echo -e "${warna_hijau}✅ Sudah Ada          : $sudah${reset}"
echo -e "${warna_merah}❌ Masih Kurang       : $kurang${reset}"

persen=$(( (sudah * 100) / total ))
echo -e "\n📈 Persentase Kelengkapan: ${warna_biru}$persen%${reset}"

if [ $kurang -eq 0 ]; then
  echo -e "${warna_hijau}🎉 SELAMAT! SEMUA FITUR SUDAH TERSEDIA!${reset}"
else
  echo -e "${warna_merah}⚠️  Silakan lengkapi fitur yang ditandai KURANG${reset}"
fi
echo -e "=================================================="

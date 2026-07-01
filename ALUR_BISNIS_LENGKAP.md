# 📋 ALUR OPERASIONAL PETANI DESA BERKAH
## Versi 1.0 - Siap Produksi

### 🟢 ALUR PENDAFTARAN & VERIFIKASI
1. Supplier Daftar Isi Data Toko
2. Upload Dokumen: KTP, Selfie KTP, NPWP(Opsional), Foto Gudang, Lahan, Timbangan
3. Kirim Pengajuan → Status Menunggu Verifikasi Admin
4. Admin Cek Kelengkapan & Kesesuaian Data
5. ✅ Disetujui: Toko Aktif Bisa Unggah Produk
   ❌ Ditolak: Ada Catatan Alasan Bisa Diajukan Ulang

### 🟢 ALUR PRODUK
1. Supplier Unggah Produk: Harga Acuan/Min/Maks, Berat, Jadwal Panen, Minimal Order
2. Produk Masuk Status: Menunggu Verifikasi Admin
3. Admin Cek Kesesuaian Harga & Kualitas
4. ✅ Disetujui: Produk Tampil di Aplikasi Pembeli
   ❌ Ditolak: Dikembalikan dengan Catatan Perbaikan

### 🟢 ALUR PENGAMBILAN BARANG (PICKUP)
1. Admin Buat Jadwal Pickup Berdasarkan Lokasi & Jadwal Panen
2. Sistem Pilih Sopir Tersedia & Sesuai Rute
3. Sopir Dapat Notifikasi Penugasan
4. Sopir Menuju Lokasi Supplier
5. Saat Sampai: Scan QR Code Pickup untuk Validasi
6. Supplier & Sopir: Foto Barang, Foto Timbangan, Tanda Tangan Digital
7. Sopir Bawa Barang Menuju Gudang Tujuan
8. Barang Sampai Gudang: Petugas Lakukan Pemeriksaan
   - Berat Aktual
   - Kondisi Kualitas
   - Keputusan: Diterima / Ditolak / Potong Harga
9. Stok Gudang Bertambah Otomatis
10. Status Pickup Menjadi Selesai

### 🟢 ALUR TRANSAKSI & SALDO
1. Pembeli Pesan Produk
2. Pesanan Dikonfirmasi
3. Barang Dikirim ke Pembeli
4. Pesanan Selesai & Dana Masuk
5. Saldo Supplier Bertambah Otomatis Sesuai Persentase
6. Supplier Ajukan Pencairan
7. Admin Verifikasi & Proses Transfer
8. Saldo Berkurang, Riwayat Tercatat

### 🟢 SISTEM NOTIFIKASI OTOMATIS KE SUPPLIER
✅ Produk Berhasil Disetujui / Ditolak
✅ Sopir Sudah Ditugaskan
✅ Sopir Sedang Menuju Lokasi
✅ Barang Sudah Diambil
✅ Barang Telah Sampai di Gudang
✅ Pemeriksaan Selesai & Hasilnya
✅ Saldo Bertambah Ada Pesanan Baru
✅ Pencairan Berhasil Diproses

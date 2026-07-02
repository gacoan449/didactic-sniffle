class Konstanta {
  // === UMUM ===
  static const String KUNCI_ID = 'id';
  static const String KUNCI_DIBUAT_PADA = 'dibuatPada';
  static const String KUNCI_DIPERBARUI_PADA = 'diperbaruiPada';
  static const String KUNCI_DIBUAT_OLEH = 'dibuatOleh';
  static const String KUNCI_DIUBAH_OLEH = 'diubahOleh';
  static const String KUNCI_DEVICE_ID = 'deviceID';
  static const String KUNCI_IP_ADDRESS = 'ipAddress';
  static const String KUNCI_VERSI_APLIKASI = 'versiAplikasi';

  // === PENGGUNA & TOKO ===
  static const String KOLEKSI_PENGGUNA = 'pengguna';
  static const String KOLEKSI_TOKO = 'toko';
  static const String KUNCI_ID_PEMBELI = 'idPembeli';
  static const String KUNCI_ID_TOKO = 'idToko';
  static const String KUNCI_ID_SUPPLIER = 'idSupplier';
  static const String KUNCI_NAMA_SUPPLIER = 'namaSupplier';
  static const String KUNCI_ID_GUDANG = 'idGudang';
  static const String KUNCI_NAMA_GUDANG = 'namaGudang';

  // === PRODUK ===
  static const String KOLEKSI_PRODUK = 'produk';
  static const String KUNCI_ID_PRODUK = 'idProduk';
  static const String KUNCI_ID_KATEGORI = 'idKategori';
  static const String KUNCI_NAMA_KATEGORI = 'namaKategori';
  static const String KUNCI_NAMA_PRODUK = 'namaProduk';
  static const String KUNCI_DESKRIPSI = 'deskripsi';
  static const String KUNCI_DAFTAR_GAMBAR = 'daftarGambar';
  static const String KUNCI_HARGA_BELI = 'hargaBeli';
  static const String KUNCI_HARGA_SATUAN = 'hargaSatuan';
  static const String KUNCI_DISKON_PRODUK = 'diskonProduk';
  static const String KUNCI_STOK = 'stok';
  static const String KUNCI_STOK_MINIMUM = 'stokMinimum';
  static const String KUNCI_BERAT = 'berat';
  static const String KUNCI_SATUAN = 'satuan';
  static const String KUNCI_KUALITAS = 'kualitas';
  static const String KUNCI_TANGGAL_PANEN = 'tanggalPanen';
  static const String KUNCI_TANGGAL_KADALUARSA = 'tanggalKadaluarsa';
  static const String KUNCI_ASAL_DESA = 'asalDesa';
  static const String KUNCI_ASAL_KECAMATAN = 'asalKecamatan';
  static const String KUNCI_ASAL_KABUPATEN = 'asalKabupaten';
  static const String KUNCI_STATUS_AKTIF = 'statusAktif';
  static const String KUNCI_DITAMPILKAN = 'ditampilkan';
  static const String KUNCI_RATA_RATA_RATING = 'rataRataRating';
  static const String KUNCI_JUMLAH_ULASAN = 'jumlahUlasan';

  // === RIWAYAT STOK ===
  static const String KOLEKSI_RIWAYAT_STOK = 'riwayatStok';
  static const String KUNCI_JUMLAH_SEBELUM = 'jumlahSebelum';
  static const String KUNCI_JUMLAH_SESUDAH = 'jumlahSesudah';
  static const String KUNCI_PERUBAHAN = 'perubahan';
  static const String KUNCI_ALASAN = 'alasan';
  static const String KUNCI_DILAKUKAN_OLEH_NAMA = 'dilakukanOlehNama';

  // === TRANSAKSI ===
  static const String KOLEKSI_TRANSAKSI = 'transaksi';
  static const String KUNCI_NO_INVOICE = 'noInvoice';
  static const String KUNCI_RIWAYAT_STATUS = 'riwayatStatus';
  static const String KUNCI_TOTAL_HARGA = 'totalHarga';
  static const String KUNCI_TOTAL_DISKON = 'totalDiskon';
  static const String KUNCI_ONGKIR = 'ongkir';
  static const String KUNCI_PPN = 'ppn';
  static const String KUNCI_BIAYA_ADMIN = 'biayaAdmin';
  static const String KUNCI_TOTAL_BAYAR = 'totalBayar';
  static const String KUNCI_BERAT_TOTAL = 'beratTotal';
  static const String KUNCI_STATUS_PEMBAYARAN = 'statusPembayaran';
  static const String KUNCI_STATUS_PENGIRIMAN = 'statusPengiriman';
  static const String KUNCI_METODE_BAYAR = 'metodeBayar';
  static const String KUNCI_STATUS_KOMPLAIN = 'statusKomplain';
  static const String KUNCI_ALASAN_KOMPLAIN = 'alasanKomplain';
  static const String KUNCI_NAMA_PENERIMA = 'namaPenerima';
  static const String KUNCI_NO_TELP_PENERIMA = 'noTelpPenerima';
  static const String KUNCI_ALAMAT_PENGIRIMAN = 'alamatPengiriman';
  static const String KUNCI_CATATAN = 'catatan';
  static const String KUNCI_NOMOR_RESI = 'nomorResi';
  static const String KUNCI_ID_KURIR = 'idKurir';
  static const String KUNCI_NAMA_KURIR = 'namaKurir';
  static const String KUNCI_PLAT_KENDARAAN = 'platKendaraan';
  static const String KUNCI_ID_SOPIR = 'idSopir';
  static const String KUNCI_NAMA_SOPIR = 'namaSopir';
  static const String KUNCI_PLAT_TRUK = 'platTruk';
  static const String KUNCI_GPS_LAT = 'gpsLat';
  static const String KUNCI_GPS_LNG = 'gpsLng';
  static const String KUNCI_ESTIMASI_SAMPAI = 'estimasiSampai';
  static const String KUNCI_FOTO_BARANG = 'fotoBarang';
  static const String KUNCI_FOTO_PENGIRIMAN = 'fotoPengiriman';
  static const String KUNCI_FOTO_DITERIMA = 'fotoDiterima';
  static const String KUNCI_OTP_TERVERIFIKASI = 'otpTerverifikasi';
  static const String KUNCI_RATING_PRODUK = 'ratingProduk';
  static const String KUNCI_RATING_KURIR = 'ratingKurir';
  static const String KUNCI_RATING_SUPPLIER = 'ratingSupplier';
  static const String KUNCI_DIBAYAR_PADA = 'dibayarPada';
  static const String KUNCI_DIKIRIM_PADA = 'dikirimPada';
  static const String KUNCI_DITERIMA_PADA = 'diterimaPada';
  static const String KUNCI_DIBATALKAN_PADA = 'dibatalkanPada';
}

// === PERAN TAMBAHAN ===
static const String PERAN_KASIR = 'kasir';
static const String PERAN_SOPIR = 'sopir';
static const String PERAN_KURIR = 'kurir';
static const String PERAN_GUDANG = 'gudang';
static const String PERAN_OWNER = 'owner';

// === MODUL KERANJANG & CHECKOUT ===
static const String KUNCI_VOUCHER = 'voucher';
static const String KUNCI_CATATAN = 'catatan';
static const String KUNCI_SIMPAN_NANTI = 'simpanNanti';
static const String KUNCI_ALAMAT_PENGIRIMAN = 'alamatPengiriman';
static const String KUNCI_KURIR = 'kurir';
static const String KUNCI_JADWAL_KIRIM = 'jadwalKirim';
static const String KUNCI_ONGKIR = 'ongkir';
static const String KUNCI_ASURANSI = 'asuransi';

// === MODUL PEMBAYARAN ===
static const String KUNCI_METODE_BAYAR = 'metodeBayar';
static const String METODE_TRANSFER = 'transfer';
static const String METODE_VA = 'virtual_akun';
static const String METODE_QRIS = 'qris';
static const String METODE_COD = 'cod';
static const String METODE_SALDO = 'saldo';
static const String METODE_CICILAN = 'cicilan';

// === MODUL DOMPET & KREDIT ===
static const String KOLEKSI_DOMPET = 'dompet';
static const String KOLEKSI_MUTASI = 'mutasi';
static const String KOLEKSI_KREDIT = 'kredit';
static const String KOLEKSI_TAGIHAN = 'tagihan';

// === MODUL MITRA & PENGIRIMAN ===
static const String KOLEKSI_SOPIR = 'sopir';
static const String KOLEKSI_KURIR = 'kurir';
static const String KOLEKSI_RIWAYAT_PERJALANAN = 'riwayatPerjalanan';
static const String KOLEKSI_LOKASI = 'lokasi';

// === MODUL GUDANG & KASIR ===
static const String KOLEKSI_BARANG_MASUK = 'barangMasuk';
static const String KOLEKSI_BARANG_KELUAR = 'barangKeluar';
static const String KOLEKSI_KAS = 'kas';
static const String KOLEKSI_LAPORAN_KAS = 'laporanKas';

// === MODUL LAINNYA ===
static const String KOLEKSI_WISHLIST = 'wishlist';
static const String KOLEKSI_VOUCHER_PENGGUNA = 'voucherPengguna';
static const String KOLEKSI_CHAT = 'chat';
static const String KOLEKSI_PESAN = 'pesan';
static const String KOLEKSI_NOTIFIKASI = 'notifikasi';
static const String KOLEKSI_LOG_AKTIVITAS = 'logAktivitas';

// === UMUM ===
enum StatusUmum {
  menunggu,
  aktif,
  nonaktif,
  disetujui,
  ditolak,
  revisi,
  suspend,
}

enum StatusVerifikasi { menunggu, disetujui, ditolak, perluRevisi }

// === PERAN PENGGUNA ===
enum JenisPengguna {
  admin,
  pemilik,
  supplier,
  kurir,
  kasir,
  gudang,
  cs,
  pembeli,
}

enum LevelMember { biasa, perak, emas, platinum }

// === PESANAN ===
enum StatusPesanan {
  dibuat,
  menungguPembayaran,
  dibayar,
  diproses,
  dikirim,
  sampai,
  selesai,
  dibatalkan,
}

enum StatusItemPesanan { tersedia, dipesan, tidakTersedia }

// === PEMBAYARAN ===
enum MetodePembayaran {
  transferBank,
  virtualAccount,
  qris,
  cod,
  saldoDompet,
  cicilan,
}

enum StatusPembayaran {
  belumBayar,
  menungguKonfirmasi,
  sudahDikonfirmasi,
  gagal,
  kadaluarsa,
}

// === PENGIRIMAN ===
enum MetodePengiriman { reguler, kilat, kargo, ambilSendiri }

enum StatusPengiriman {
  diproses,
  menungguKurir,
  diantar,
  dalamPerjalanan,
  sampai,
}

// === RETUR & REFUND ===
enum StatusRetur { diajukan, disetujui, ditolak, dikirim, diterima, selesai }

enum StatusRefund { diajukan, disetujui, ditolak, diproses, selesai }

// === PROMO & VOUCHER ===
enum JenisPromo { diskonPersen, diskonNominal, beliGratis, flashSale }

enum PrioritasPromo { rendah, menengah, tinggi, utama }

enum JenisVoucher { seluruhToko, kategori, produk, ongkir, khususMember }

enum StatusVoucher { aktif, kadaluarsa, habisKuota, dinonaktifkan }

// === STOK ===
enum MetodeStok { fifo, lifo, fefo }

enum StatusStok { tersedia, dipesan, rusak, kadaluarsa, retur }

// === NOTIFIKASI ===
enum TipeNotifikasi {
  sistem,
  pesanan,
  pembayaran,
  pengiriman,
  promo,
  pesan,
  peringatan,
}

enum StatusNotifikasi { belumDibaca, sudahDibaca, diarsipkan }

// === CHAT ===
enum TipePesan { teks, gambar, video, suara, dokumen, sistem }

enum StatusPesan { terkirim, diterima, dibaca, diedit, dihapus }

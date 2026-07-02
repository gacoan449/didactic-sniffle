enum StatusKas { buka, tutup }

enum StatusMitra { menunggu, aktif, suspend, nonaktif }

enum StatusDompet { aktif, diblokir, verifikasi }

enum StatusPengajuanKredit { diajukan, disetujui, ditolak, diperbaiki }

enum StatusKontrakKredit { aktif, lunas, macet, dihapus }

enum StatusTagihan { belumBayar, menunggu, sudahBayar, lewatJatuhTempo, denda }

enum TipePesan { teks, gambar, video, suara, dokumen, sistem }

enum StatusPesan { terkirim, diterima, dibaca, diedit, dihapus }

enum TipeMutasi { masuk, keluar, tahan, lepasTahan }

enum FIFO {
  pertamaMasukPertamaKeluar,
  terakhirMasukPertamaKeluar,
  kadaluarsaPertama,
}

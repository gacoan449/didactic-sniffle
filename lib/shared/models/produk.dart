class ProductModel {
  // ==========================
  // IDENTITAS PRODUK
  // ==========================
  final String id;
  final String nama;
  final String slug;
  final String deskripsi;

  // ==========================
  // MEDIA
  // ==========================
  final List<String> gambarUrl;
  final String? videoUrl;

  // ==========================
  // HARGA
  // ==========================
  final int hargaModal;
  final int hargaPromo;
  final int hargaLama;
  final int diskon;

  // ==========================
  // STOK
  // ==========================
  final int stok;
  final int minimalPembelian;
  final int maksimalPembelian;

  // ==========================
  // UKURAN
  // ==========================
  final double berat;
  final double panjang;
  final double lebar;
  final double tinggi;
  final String satuan;

  // ==========================
  // KATEGORI
  // ==========================
  final String kategoriId;
  final String subKategoriId;

  // ==========================
  // SUPPLIER
  // ==========================
  final String supplierId;
  final String supplierNama;
  final String supplierAlamat;
  final String supplierTelepon;

  // ==========================
  // LOKASI
  // ==========================
  final String kabupaten;
  final String provinsi;

  // ==========================
  // STATISTIK
  // ==========================
  final double rating;
  final int jumlahUlasan;
  final int terjual;
  final int dilihat;
  final int disukai;

  // ==========================
  // STATUS
  // ==========================
  final bool isPromo;
  final bool isBaru;
  final bool isTerlaris;
  final bool isOrganik;
  final bool isAktif;

  // ==========================
  // PENGIRIMAN
  // ==========================
  final String estimasiKirim;
  final bool ongkirGratis;
  final String garansi;

  // ==========================
  // TANGGAL
  // ==========================
  final DateTime? tanggalPanen;
  final DateTime? expiredDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    required this.nama,
    required this.slug,
    required this.deskripsi,

    required this.gambarUrl,
    this.videoUrl,

    required this.hargaModal,
    required this.hargaPromo,
    required this.hargaLama,
    required this.diskon,

    required this.stok,
    required this.minimalPembelian,
    required this.maksimalPembelian,

    required this.berat,
    required this.panjang,
    required this.lebar,
    required this.tinggi,
    required this.satuan,

    required this.kategoriId,
    required this.subKategoriId,

    required this.supplierId,
    required this.supplierNama,
    required this.supplierAlamat,
    required this.supplierTelepon,

    required this.kabupaten,
    required this.provinsi,

    required this.rating,
    required this.jumlahUlasan,
    required this.terjual,
    required this.dilihat,
    required this.disukai,

    required this.isPromo,
    required this.isBaru,
    required this.isTerlaris,
    required this.isOrganik,
    required this.isAktif,

    required this.estimasiKirim,
    required this.ongkirGratis,
    required this.garansi,

    this.tanggalPanen,
    this.expiredDate,

    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nama": nama,
      "slug": slug,
      "deskripsi": deskripsi,

      "gambarUrl": gambarUrl,
      "videoUrl": videoUrl,

      "hargaModal": hargaModal,
      "hargaPromo": hargaPromo,
      "hargaLama": hargaLama,
      "diskon": diskon,

      "stok": stok,
      "minimalPembelian": minimalPembelian,
      "maksimalPembelian": maksimalPembelian,

      "berat": berat,
      "panjang": panjang,
      "lebar": lebar,
      "tinggi": tinggi,
      "satuan": satuan,

      "kategoriId": kategoriId,
      "subKategoriId": subKategoriId,

      "supplierId": supplierId,
      "supplierNama": supplierNama,
      "supplierAlamat": supplierAlamat,
      "supplierTelepon": supplierTelepon,

      "kabupaten": kabupaten,
      "provinsi": provinsi,

      "rating": rating,
      "jumlahUlasan": jumlahUlasan,
      "terjual": terjual,
      "dilihat": dilihat,
      "disukai": disukai,

      "isPromo": isPromo,
      "isBaru": isBaru,
      "isTerlaris": isTerlaris,
      "isOrganik": isOrganik,
      "isAktif": isAktif,

      "estimasiKirim": estimasiKirim,
      "ongkirGratis": ongkirGratis,
      "garansi": garansi,

      "tanggalPanen": tanggalPanen?.millisecondsSinceEpoch,
      "expiredDate": expiredDate?.millisecondsSinceEpoch,

      "createdAt": createdAt.millisecondsSinceEpoch,
      "updatedAt": updatedAt.millisecondsSinceEpoch,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      nama: data["nama"] ?? "",
      slug: data["slug"] ?? "",
      deskripsi: data["deskripsi"] ?? "",

      gambarUrl: List<String>.from(data["gambarUrl"] ?? []),
      videoUrl: data["videoUrl"],

      hargaModal: data["hargaModal"] ?? 0,
      hargaPromo: data["hargaPromo"] ?? 0,
      hargaLama: data["hargaLama"] ?? 0,
      diskon: data["diskon"] ?? 0,

      stok: data["stok"] ?? 0,
      minimalPembelian: data["minimalPembelian"] ?? 1,
      maksimalPembelian: data["maksimalPembelian"] ?? 100,

      berat: (data["berat"] ?? 0).toDouble(),
      panjang: (data["panjang"] ?? 0).toDouble(),
      lebar: (data["lebar"] ?? 0).toDouble(),
      tinggi: (data["tinggi"] ?? 0).toDouble(),
      satuan: data["satuan"] ?? "kg",

      kategoriId: data["kategoriId"] ?? "",
      subKategoriId: data["subKategoriId"] ?? "",

      supplierId: data["supplierId"] ?? "",
      supplierNama: data["supplierNama"] ?? "",
      supplierAlamat: data["supplierAlamat"] ?? "",
      supplierTelepon: data["supplierTelepon"] ?? "",

      kabupaten: data["kabupaten"] ?? "",
      provinsi: data["provinsi"] ?? "",

      rating: (data["rating"] ?? 0).toDouble(),
      jumlahUlasan: data["jumlahUlasan"] ?? 0,
      terjual: data["terjual"] ?? 0,
      dilihat: data["dilihat"] ?? 0,
      disukai: data["disukai"] ?? 0,

      isPromo: data["isPromo"] ?? false,
      isBaru: data["isBaru"] ?? false,
      isTerlaris: data["isTerlaris"] ?? false,
      isOrganik: data["isOrganik"] ?? false,
      isAktif: data["isAktif"] ?? true,

      estimasiKirim: data["estimasiKirim"] ?? "",
      ongkirGratis: data["ongkirGratis"] ?? false,
      garansi: data["garansi"] ?? "",

      tanggalPanen: data["tanggalPanen"] != null
          ? DateTime.fromMillisecondsSinceEpoch(data["tanggalPanen"])
          : null,

      expiredDate: data["expiredDate"] != null
          ? DateTime.fromMillisecondsSinceEpoch(data["expiredDate"])
          : null,

      createdAt: DateTime.fromMillisecondsSinceEpoch(
        data["createdAt"] ?? DateTime.now().millisecondsSinceEpoch,
      ),

      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        data["updatedAt"] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}

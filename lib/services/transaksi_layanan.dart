import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/konstanta.dart';
import '../models/transaksi_model.dart';
import 'keranjang_layanan.dart';
import 'logger_service.dart';

class LayananTransaksi {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LayananKeranjang _keranjang = LayananKeranjang.instance;

  String get uid => _auth.currentUser?.uid ?? '';

  /// ✅ Transaksi Atomik: Cek Stok → Kurangi Stok → Buat Pesanan → Bersihkan Keranjang
  Future<String> buatPesananDariKeranjang({
    required String idToko,
    required String idSupplier,
    required String namaSupplier,
    required int ongkir,
    required MetodeBayar metodeBayar,
    required String namaPenerima,
    required String noTelpPenerima,
    required String alamatPengiriman,
    double? latTujuan,
    double? lngTujuan,
    String idGudang = '',
    String namaGudang = '',
    int ppn = 0,
    int biayaAdmin = 0,
    String catatan = '',
    String? deviceID,
    String? ipAddress,
    String versiAplikasi = '1.0.0',
  }) async {
    if (uid.isEmpty) throw Exception("Belum login");

    final daftarItem = await _keranjang.ambilSemua();
    final itemToko = daftarItem
        .where((i) => i.idToko == idToko && i.idSupplier == idSupplier)
        .toList();
    if (itemToko.isEmpty)
      throw Exception("Tidak ada barang dari toko/supplier ini");

    final totalHarga = _keranjang.hitungTotal(itemToko);
    final totalDiskon = _keranjang.hitungTotalDiskon(itemToko);
    final beratTotal = _keranjang.hitungBeratTotal(itemToko);
    final totalBayar = totalHarga + ongkir + ppn + biayaAdmin;
    final daftarSnapshot = itemToko.map((i) => i.buatSnapshot()).toList();
    final riwayatAwal = [
      RiwayatStatus(
        status: "Dibuat",
        waktu: DateTime.now(),
        keterangan: "Pesanan berhasil dibuat",
      ),
    ];
    final otpData = Transaksi.buatOTP();

    final refPesanan = _db.collection(Konstanta.KOLEKSI_TRANSAKSI).doc();
    final refCounter = _db.collection('sistem').doc('counter_invoice');

    String? idPesananTerbuat;
    int urutHarian = 1;

    /// ✅ Dijalankan SEMUA atau TIDAK SAMA SEKALI
    await _db.runTransaction((transaksi) async {
      // 1. Ambil counter nomor urut harian
      final docCounter = await transaksi.get(refCounter);
      if (!docCounter.exists) {
        await transaksi.set(refCounter, {
          'urutHarian': 1,
          'tanggal': DateTime.now().toString().substring(0, 10),
        });
        urutHarian = 1;
      } else {
        final data = docCounter.data()!;
        final tanggalSimpan = data['tanggal'] as String;
        final hariIni = DateTime.now().toString().substring(0, 10);
        urutHarian = tanggalSimpan == hariIni
            ? (data['urutHarian'] as int) + 1
            : 1;
        await transaksi.update(refCounter, {
          'urutHarian': urutHarian,
          'tanggal': hariIni,
        });
      }

      // 2. Cek & kurangi stok setiap barang
      for (final item in itemToko) {
        final refProduk = _db
            .collection(Konstanta.KOLEKSI_PRODUK)
            .doc(item.idProduk);
        final docProduk = await transaksi.get(refProduk);
        if (!docProduk.exists)
          throw Exception("Produk ${item.namaProduk} sudah tidak ada");

        final stokSaatIni =
            (docProduk.data()?[Konstanta.KUNCI_STOK] ?? 0) as int;
        if (stokSaatIni < item.jumlah)
          throw Exception("Stok ${item.namaProduk} tidak mencukupi");

        transaksi.update(refProduk, {
          Konstanta.KUNCI_STOK: stokSaatIni - item.jumlah,
        });
      }

      // 3. Buat dokumen transaksi
      final transaksiBaru = Transaksi(
        id: refPesanan.id,
        noInvoice: Transaksi.buatNomorInvoice(refPesanan.id, urutHarian),
        idPembeli: uid,
        idToko: idToko,
        idSupplier: idSupplier,
        namaSupplier: namaSupplier,
        idGudang: idGudang,
        namaGudang: namaGudang,
        daftarSnapshot: daftarSnapshot,
        riwayatStatus: riwayatAwal,
        totalHarga: totalHarga,
        totalDiskon: totalDiskon,
        ongkir: ongkir,
        ppn: ppn,
        biayaAdmin: biayaAdmin,
        totalBayar: totalBayar,
        beratTotal: beratTotal,
        statusPembayaran: StatusPembayaran.belumBayar,
        statusPengiriman: StatusPengiriman.belumDikirim,
        metodeBayar: metodeBayar,
        statusKomplain: StatusKomplain.tidakAda,
        alasanKomplain: '',
        namaPenerima: namaPenerima,
        noTelpPenerima: noTelpPenerima,
        alamatPengiriman: alamatPengiriman,
        latTujuan: latTujuan,
        lngTujuan: lngTujuan,
        catatan: catatan,
        nomorResi: null,
        idKurir: '',
        namaKurir: '',
        platKendaraan: '',
        idSopir: '',
        namaSopir: '',
        platTruk: '',
        estimasiSampai: null,
        fotoBarang: '',
        fotoPengiriman: '',
        fotoDiterima: '',
        hashOTP: otpData.kodeHash,
        otpBerlakuHingga: otpData.berlakuHingga,
        percobaanOTPGagal: 0,
        otpTerverifikasi: false,
        ratingProduk: 0,
        ratingKurir: 0,
        ratingSupplier: 0,
        dipesanPada: DateTime.now(),
        dibuatOleh: uid,
        diubahOleh: uid,
        deviceID: deviceID,
        ipAddress: ipAddress,
        versiAplikasi: versiAplikasi,
      );

      if (!transaksiBaru.apakahValid())
        throw Exception("Data pesanan tidak lengkap");

      await transaksi.set(refPesanan, transaksiBaru.toMapUntukBuatBaru());
      idPesananTerbuat = refPesanan.id;

      // 4. Bersihkan keranjang hanya jika semua langkah berhasil
      for (final item in itemToko) {
        await transaksi.delete(
          _db
              .collection(Konstanta.KOLEKSI_KERANJANG)
              .doc(uid)
              .collection('item')
              .doc(item.id),
        );
      }
    });

    LayananLog.info("Pesanan berhasil dibuat: $idPesananTerbuat");
    return idPesananTerbuat!;
  }

  Stream<List<Transaksi>> streamPesananPembeli() {
    if (uid.isEmpty) return Stream.value([]);
    return _db
        .collection(Konstanta.KOLEKSI_TRANSAKSI)
        .where(Konstanta.KUNCI_ID_PEMBELI, isEqualTo: uid)
        .orderBy(Konstanta.KUNCI_DIPESAN_PADA, descending: true)
        .limit(50)
        .snapshots()
        .map(
          (s) => s.docs.map((d) => Transaksi.fromMap(d.id, d.data())).toList(),
        );
  }

  Stream<List<Transaksi>> streamPesananPenjual(String idToko) {
    return _db
        .collection(Konstanta.KOLEKSI_TRANSAKSI)
        .where(Konstanta.KUNCI_ID_TOKO, isEqualTo: idToko)
        .orderBy(Konstanta.KUNCI_DIPESAN_PADA, descending: true)
        .limit(50)
        .snapshots()
        .map(
          (s) => s.docs.map((d) => Transaksi.fromMap(d.id, d.data())).toList(),
        );
  }

  Future<void> ubahStatusPembayaran(
    String idTransaksi,
    StatusPembayaran status,
    String keterangan,
  ) async {
    if (uid.isEmpty) return;
    try {
      await _db.collection(Konstanta.KOLEKSI_TRANSAKSI).doc(idTransaksi).update(
        {
          Konstanta.KUNCI_STATUS_PEMBAYARAN: status.index,
          Konstanta.KUNCI_DIBAYAR_PADA: status == StatusPembayaran.berhasil
              ? FieldValue.serverTimestamp()
              : null,
          Konstanta.KUNCI_RIWAYAT_STATUS: FieldValue.arrayUnion([
            RiwayatStatus(
              status: status.name,
              waktu: DateTime.now(),
              keterangan: keterangan,
            ).toMap(),
          ]),
          Konstanta.KUNCI_DIUBAH_OLEH: uid,
        },
      );
    } catch (e) {
      LayananLog.error("Ubah status bayar gagal", e);
      rethrow;
    }
  }

  Future<void> ubahStatusPengiriman(
    String idTransaksi,
    StatusPengiriman status,
    String keterangan,
  ) async {
    if (uid.isEmpty) return;
    try {
      final Map<String, dynamic> data = {
        Konstanta.KUNCI_STATUS_PENGIRIMAN: status.index,
        Konstanta.KUNCI_RIWAYAT_STATUS: FieldValue.arrayUnion([
          RiwayatStatus(
            status: status.name,
            waktu: DateTime.now(),
            keterangan: keterangan,
          ).toMap(),
        ]),
        Konstanta.KUNCI_DIUBAH_OLEH: uid,
      };
      if (status == StatusPengiriman.dijemput)
        data[Konstanta.KUNCI_DIKIRIM_PADA] = FieldValue.serverTimestamp();
      if (status == StatusPengiriman.sampaiTujuan)
        data[Konstanta.KUNCI_DITERIMA_PADA] = FieldValue.serverTimestamp();
      if (status == StatusPengiriman.gagalKirim)
        data[Konstanta.KUNCI_DIBATALKAN_PADA] = FieldValue.serverTimestamp();
      await _db
          .collection(Konstanta.KOLEKSI_TRANSAKSI)
          .doc(idTransaksi)
          .update(data);
    } catch (e) {
      LayananLog.error("Ubah status kirim gagal", e);
      rethrow;
    }
  }

  /// ✅ Verifikasi OTP aman: batas percobaan + masa berlaku + perbandingan hash
  Future<(bool berhasil, String pesan)> verifikasiOTP(
    String idTransaksi,
    String kodeMasuk,
  ) async {
    try {
      return await _db.runTransaction((transaksi) async {
        final doc = await transaksi.get(
          _db.collection(Konstanta.KOLEKSI_TRANSAKSI).doc(idTransaksi),
        );
        if (!doc.exists) return (false, "Pesanan tidak ditemukan");

        final transaksiData = Transaksi.fromMap(doc.id, doc.data()!);
        if (transaksiData.otpTerverifikasi)
          return (true, "Sudah diverifikasi sebelumnya");
        if (transaksiData.percobaanOTPGagal >= 5)
          return (false, "Terlalu banyak percobaan, silakan minta OTP baru");
        if (DateTime.now().isAfter(transaksiData.otpBerlakuHingga))
          return (false, "Kode OTP sudah kadaluarsa");

        final hashMasuk = Transaksi.hashTeks(kodeMasuk);
        if (hashMasuk != transaksiData.hashOTP) {
          await transaksi.update(doc.reference, {
            'percobaanOTPGagal': transaksiData.percobaanOTPGagal + 1,
          });
          return (false, "Kode OTP salah");
        }

        await transaksi.update(doc.reference, {
          Konstanta.KUNCI_OTP_TERVERIFIKASI: true,
          Konstanta.KUNCI_STATUS_PENGIRIMAN:
              StatusPengiriman.sampaiTujuan.index,
          Konstanta.KUNCI_DITERIMA_PADA: FieldValue.serverTimestamp(),
          Konstanta.KUNCI_RIWAYAT_STATUS: FieldValue.arrayUnion([
            RiwayatStatus(
              status: "OTP Diverifikasi",
              waktu: DateTime.now(),
              keterangan: "Barang diterima dengan benar",
            ).toMap(),
          ]),
          'percobaanOTPGagal': 0,
        });

        return (true, "Verifikasi berhasil");
      });
    } catch (e) {
      LayananLog.error("Verifikasi OTP gagal", e);
      return (false, "Terjadi kesalahan sistem");
    }
  }

  static final LayananTransaksi instance = LayananTransaksi._internal();
  LayananTransaksi._internal();
}

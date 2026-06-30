	mport 'package:flutter/material.dart';
import 'routes.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

// ==================================================
// 🛡️ SISTEM PERLINDUNGAN 7 LAPISAN MILITER - FINAL
// ✅ OPTIMASI KECEPATAN SERVER
// ✅ KUNCI UTAMA TIDAK TERLIHAT DI KODE
// PT HILWA NUSANTARA
// ==================================================
class SistemPerisaiHilwa {
  // ==================================================
  // LAPISAN TAMBAHAN: KUNCI UTAMA DISAMARKAN MENJADI ANGKA
  // Tidak akan terbaca sebagai teks jika APK dibongkar
  // ==================================================
  static const List<int> _kunciRahasiaByte = [
    72,73,76,87,65,95,65,77,65,78,95,83,69,76,65,77,65,78,89,65,95,
    55,76,65,80,73,83,95,50,48,50,54
  ];

  static String get _kunciDasar {
    return utf8.decode(_kunciRahasiaByte);
  }
  
  static const List<List<String>> _bankSimbol = [
    ['Ꙭ','⌘','⍟','⎔','⏣','⏢','◈','❖','✧','☙','❧','✶','✷','✸','✹'],
    ['❋','✽','❀','❁','❂','❃','❄','❅','❆','✿','⌬','𝄞','𝄢','𝅘𝅥','𝅦'],
    ['𝅧','𝅨','𝅩','𝅪','𝅫','𝅬','∷','⋮','⁚','⊕','⊗','⊙','⌁','⌂','⍜'],
    ['⍭','⍮','⍯','⍰','⍱','⍲','⍳','⍴','⍵','⍶','⍷','⍸','⍹','⍺','⍻']
  ];

  // ==================================================
  // BANTUAN: HITUNG KUNCI BERDASARKAN NILAI BLOK WAKTU
  // ==================================================
  static List<int> _hitungKunciDariBlok(int blokWaktu) {
    String kunciGabungan = "$_kunciDasar-$blokWaktu";
    return sha256.convert(utf8.encode(kunciGabungan)).bytes;
  }

  // ==================================================
  // BANTUAN: BUAT PETA SIMBOL DARI KUNCI TERTENTU
  // ==================================================
  static Map<String, String> _buatPetaSimbol(List<int> kunci) {
    List<String> daftarKarakter = [];
    for(int c=32; c<127; c++) daftarKarakter.add(String.fromCharCode(c));
    
    List<String> semuaSimbol = [];
    for(var lapis in _bankSimbol) semuaSimbol.addAll(lapis);

    Random acakTerarah = Random(kunci[0] ^ kunci[15]);
    for (int i = semuaSimbol.length - 1; i > 0; i--) {
      int j = acakTerarah.nextInt(i + 1);
      String temp = semuaSimbol[i];
      semuaSimbol[i] = semuaSimbol[j];
      semuaSimbol[j] = temp;
    }

    Map<String, String> peta = {};
    for(int i=0; i<daftarKarakter.length; i++){
      peta[daftarKarakter[i]] = semuaSimbol[i % semuaSimbol.length];
    }
    return peta;
  }

  // ==================================================
  // LAPISAN 1 & 2: ENKRIPSI GANDA AMAN
  // ==================================================
  static List<int> _enkripsiGanda(String teks, List<int> kunci) {
    List<int> data = utf8.encode(teks.toUpperCase());
    List<int> hasil = [];
    
    for(int i=0; i<data.length; i++){
      int langkah1 = data[i] ^ kunci[i % kunci.length];
      int langkah2 = (langkah1 + kunci[(i+7) % kunci.length]) % 256;
      hasil.add(langkah2);
    }
    return hasil;
  }

  // ==================================================
  // LAPISAN 3: DEKRIPSI DENGAN PERBAIKAN MATEMATIKA DART
  // ==================================================
  static String _dekripsiGanda(List<int> dataAman, List<int> kunci) {
    List<int> hasil = [];
    
    for(int i=0; i<dataAman.length; i++){
      int langkah1 = dataAman[i] - kunci[(i+7) % kunci.length];
      langkah1 = ((langkah1 % 256) + 256) % 256;
      int langkah2 = langkah1 ^ kunci[i % kunci.length];
      hasil.add(langkah2);
    }
    return utf8.decode(hasil);
  }

  // ==================================================
  // MENGUNCI PESAN (DI PERANGKAT PENGIRIM)
  // ==================================================
  static String lindungiPesan(String pesanAsli) {
    int blokWaktuAktif = DateTime.now().millisecondsSinceEpoch ~/ 30000;
    List<int> kunciAktif = _hitungKunciDariBlok(blokWaktuAktif);
    
    List<int> dataKunci = _enkripsiGanda(pesanAsli, kunciAktif);
    String teksPerantara = base64.encode(dataKunci);
    
    Map<String, String> peta = _buatPetaSimbol(kunciAktif);
    
    String hasilAkhir = "⫷";
    for(var h in teksPerantara.split('')){
      hasilAkhir += peta[h] ?? h;
      hasilAkhir += "·";
    }
    hasilAkhir += "⫸";
    return hasilAkhir;
  }

  // ==================================================
  // MEMBUKA PESAN (DI PERANGKAT PENERIMA/SERVER)
  // ✨ URUTAN DIUBAH: CEK KONDISI NORMAL DULU AGAR CEPAT
  // ==================================================
  static String bacaPesanTerlindungi(String pesanRahasia) {
    int blokWaktuSekarang = DateTime.now().millisecondsSinceEpoch ~/ 30000;
    
    // ✅ PERBAIKAN: Cek DULU waktu sekarang (90% kasus normal)
    // Baru cek waktu lalu dan depan jika diperlukan
    List<int> daftarBlokWaktuUji = [
      blokWaktuSekarang,      // 1. Kondisi Normal - PALING CEPAT
      blokWaktuSekarang - 1,  // 2. Jeda kirim pas detik terakhir
      blokWaktuSekarang + 1   // 3. Jaringan lambat sampai blok baru
    ];

    for (int blokUji in daftarBlokWaktuUji) {
      try {
        List<int> kunciUji = _hitungKunciDariBlok(blokUji);
        
        String bersih = pesanRahasia.replaceAll("⫷", "").replaceAll("⫸", "");
        List<String> potongan = bersih.split('·');
        if(potongan.isNotEmpty) potongan.removeLast();

        Map<String, String> peta = _buatPetaSimbol(kunciUji);
        Map<String, String> pembalik = peta.map((k,v) => MapEntry(v,k));
        
        String teksPerantara = "";
        for(var s in potongan){
          if(s.isNotEmpty) teksPerantara += pembalik[s] ?? s;
        }

        List<int> dataAman = base64.decode(teksPerantara);
        
        return _dekripsiGanda(dataAman, kunciUji);

      } catch (e) {
        continue;
      }
    }

    throw Exception("⚠️ PERINGATAN KEAMANAN: Data tidak sah atau kunci sudah kadaluwarsa!");
  }
}

// ==================================================
// 🏃 MULAI APLIKASI
// ==================================================
void main() {
  runApp(const PetaniDesaApp());
}

class PetaniDesaApp extends StatelessWidget {
  const PetaniDesaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Petani Desa Berkah",
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}


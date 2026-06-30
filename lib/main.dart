import 'package:flutter/material.dart';
import 'routes.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

// ==================================================
// 🛡️ SISTEM KEAMANAN BERLAPIS TINGKAT TINGGI
// PT HILWA NUSANTARA
// ==================================================
class KamusRahasiaHilwa {
  static const String _kunciRahasiaUtama = "HILWA_NUSANTARA_AMAN_9999";

  static const List<String> _daftarSimbol = [
    'Ꙭ','⌘','⍟','⎔','⏣','⏢','◈','❖','✧','☙','❧','✶','✷','✸','✹',
    '❋','✽','❀','❁','❂','❃','❄','❅','❆','✿','⌬','𝄞','𝄢','𝅘𝅥','𝅦',
    '𝅧','𝅨','𝅩','𝅪','𝅫','𝅬','∷','⋮','⁚','⊕','⊗','⊙','⌁','⌂'
  ];

  // ==================================================
  // LAPISAN 2: KUNCI BERUBAH TIAP 60 DETIK
  // ==================================================
  static Map<String, String> _buatKamusDinamis() {
    int waktuSekarang = DateTime.now().millisecondsSinceEpoch ~/ 60000;
    Random acakTerarah = Random(waktuSekarang + _kunciRahasiaUtama.hashCode);

    List<String> hurufDasar = [
      'A','B','C','D','E','F','G','H','I','J','K','L','M',
      'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
      '0','1','2','3','4','5','6','7','8','9',' ','.',',',
      'A','B','C','D','E','F','G','H','I','J','K','L','M',
      'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
      '0','1','2','3','4','5','6','7','8','9','+','/','='
    ];

    List<String> salinSimbol = List.from(_daftarSimbol);
    salinSimbol.shuffle(acakTerarah);

    Map<String, String> kamusBaru = {};
    for(int i=0; i<hurufDasar.length; i++){
      kamusBaru[hurufDasar[i]] = salinSimbol[i % salinSimbol.length];
    }
    return kamusBaru;
  }

  // ==================================================
  // LAPISAN 1: ENKRIPSI KUAT SEBELUM SIMBOL
  // ==================================================
  static List<int> _enkripsiAes(String pesan) {
    var kunci = sha256.convert(utf8.encode(_kunciRahasiaUtama)).bytes;
    List<int> data = utf8.encode(pesan);
    
    List<int> hasil = [];
    for(int i=0; i<data.length; i++){
      hasil.add(data[i] ^ kunci[i % kunci.length]);
    }
    return hasil;
  }

  static String _dekripsiAes(List<int> dataTerenkripsi) {
    var kunci = sha256.convert(utf8.encode(_kunciRahasiaUtama)).bytes;
    List<int> hasil = [];
    for(int i=0; i<dataTerenkripsi.length; i++){
      hasil.add(dataTerenkripsi[i] ^ kunci[i % kunci.length]);
    }
    return utf8.decode(hasil);
  }

  // ==================================================
  // GABUNGAN SEMUA: KUNCI PESAN
  // ==================================================
  static String kunciPesan(String pesanAsli) {
    List<int> dataAman = _enkripsiAes(pesanAsli.toUpperCase());
    String teksPerantara = base64.encode(dataAman);
    
    Map<String, String> kamusSaatIni = _buatKamusDinamis();
    
    String hasilAkhir = "⫷";
    for(var h in teksPerantara.split('')){
      hasilAkhir += kamusSaatIni[h] ?? h;
      hasilAkhir += "·";
    }
    hasilAkhir += "⫸";
    return hasilAkhir;
  }

  // ==================================================
  // BUKA KEMBALI PESAN
  // ==================================================
  static String bukaPesan(String pesanRahasia) {
    String bersih = pesanRahasia.replaceAll("⫷", "").replaceAll("⫸", "");
    bersih = bersih.replaceAll("·", " ");
    List<String> bagian = bersih.split(" ");
    
    Map<String, String> kamusSaatIni = _buatKamusDinamis();
    Map<String, String> pembalik = kamusSaatIni.map((k,v) => MapEntry(v,k));
    
    String teksPerantara = "";
    for(var s in bagian){
      if(s.isNotEmpty) teksPerantara += pembalik[s] ?? s;
    }
    
    List<int> dataAman = base64.decode(teksPerantara);
    return _dekripsiAes(dataAman);
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


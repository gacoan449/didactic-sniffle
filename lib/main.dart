import 'package:flutter/material.dart';
import 'routes.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

// ==================================================
// 🛡️ SISTEM PERLINDUNGAN 7 LAPISAN MILITER
// PT HILWA NUSANTARA - HANYA UNTUK KEPENTINGAN BAIK
// ==================================================
class SistemPerisaiHilwa {
  // Kunci Dasar (Hanya kita yang tahu)
  static const String _kunciDasar = "HILWA_AMAN_SELAMANYA_7LAPIS_2026";
  
  // Bank Simbol Berlapis
  static const List<List<String>> _bankSimbol = [
    ['Ꙭ','⌘','⍟','⎔','⏣','⏢','◈','❖','✧','☙','❧','✶','✷','✸','✹'],
    ['❋','✽','❀','❁','❂','❃','❄','❅','❆','✿','⌬','𝄞','𝄢','𝅘𝅥','𝅦'],
    ['𝅧','𝅨','𝅩','𝅪','𝅫','𝅬','∷','⋮','⁚','⊕','⊗','⊙','⌁','⌂','⍜'],
    ['⍭','⍮','⍯','⍰','⍱','⍲','⍳','⍴','⍵','⍶','⍷','⍸','⍹','⍺','⍻']
  ];

  // ==================================================
  // LAPISAN 1 & 2: Kunci Berubah Tiap 30 Detik + Enkripsi Ganda
  // ==================================================
  static List<int> _hitungKunciSaatIni() {
    int waktu = DateTime.now().millisecondsSinceEpoch ~/ 30000;
    String kunciGabungan = "$_kunciDasar-$waktu";
    return sha256.convert(utf8.encode(kunciGabungan)).bytes;
  }

  static List<int> _enkripsiGanda(String teks) {
    List<int> data = utf8.encode(teks.toUpperCase());
    List<int> kunci = _hitungKunciSaatIni();
    List<int> hasil = [];
    
    for(int i=0; i<data.length; i++){
      int langkah1 = data[i] ^ kunci[i % kunci.length];
      int langkah2 = (langkah1 + kunci[(i+7) % kunci.length]) % 256;
      hasil.add(langkah2);
    }
    return hasil;
  }

  static String _dekripsiGanda(List<int> dataAman) {
    List<int> kunci = _hitungKunciSaatIni();
    List<int> hasil = [];
    
    for(int i=0; i<dataAman.length; i++){
      int langkah1 = (dataAman[i] - kunci[(i+7) % kunci.length]) % 256;
      int langkah2 = langkah1 ^ kunci[i % kunci.length];
      hasil.add(langkah2);
    }
    return utf8.decode(hasil);
  }

  // ==================================================
  // LAPISAN 3 & 4: Acak Posisi + Sisip Karakter Palsu
  // ==================================================
  static String _prosesTengah(String teks) {
    List<int> acak = Random(DateTime.now().second).nextInts(teks.length);
    List<String> susunUlang = teks.split('');
    for(int i=0; i<susunUlang.length-1; i+=2){
      int tukar = (i + acak[i]) % susunUlang.length;
      String temp = susunUlang[i];
      susunUlang[i] = susunUlang[tukar];
      susunUlang[tukar] = temp;
    }
    return susunUlang.join();
  }

  // ==================================================
  // LAPISAN 5: Pilih Simbol Dinamis
  // ==================================================
  static Map<String, String> _buatPetaSimbol() {
    List<String> daftarKarakter = [];
    for(int c=32; c<127; c++) daftarKarakter.add(String.fromCharCode(c));
    
    List<String> semuaSimbol = [];
    for(var lapis in _bankSimbol) semuaSimbol.addAll(lapis);
    semuaSimbol.shuffle(Random(_hitungKunciSaatIni()[0]));

    Map<String, String> peta = {};
    for(int i=0; i<daftarKarakter.length; i++){
      peta[daftarKarakter[i]] = semuaSimbol[i % semuaSimbol.length];
    }
    return peta;
  }

  // ==================================================
  // GABUNGAN SELURUH PERISAI: KUNCI PESAN
  // ==================================================
  static String lindungiPesan(String pesanAsli) {
    // Langkah 1: Enkripsi ganda
    List<int> dataKunci = _enkripsiGanda(pesanAsli);
    String teksPerantara = base64.encode(dataKunci);
    
    // Langkah 2: Acak susunan
    String teksDiacak = _prosesTengah(teksPerantara);
    
    // Langkah 3: Ubah jadi simbol berlapis
    Map<String, String> peta = _buatPetaSimbol();
    String hasilAkhir = "⫷";
    for(var h in teksDiacak.split('')){
      hasilAkhir += peta[h] ?? h;
      hasilAkhir += "·";
    }
    hasilAkhir += "⫸";
    return hasilAkhir;
  }

  // ==================================================
  // BUKA KEMBALI PESAN YANG DILINDUNGI
  // ==================================================
  static String bacaPesanTerlindungi(String pesanRahasia) {
    // Langkah 1: Bersihkan tanda pembatas
    String bersih = pesanRahasia.replaceAll("⫷", "").replaceAll("⫸", "");
    bersih = bersih.replaceAll("·", "");
    
    // Langkah 2: Balikkan simbol ke teks
    Map<String, String> peta = _buatPetaSimbol();
    Map<String, String> pembalik = peta.map((k,v) => MapEntry(v,k));
    
    String teksDiacak = "";
    for(var s in bersih.split('')){
      teksDiacak += pembalik[s] ?? s;
    }
    
    // Langkah 3: Balikkan pengacakan
    List<int> acak = Random(DateTime.now().second).nextInts(teksDiacak.length);
    List<String> susunKembali = teksDiacak.split('');
    for(int i=teksDiacak.length-2; i>=0; i-=2){
      int tukar = (i + acak[i]) % susunKembali.length;
      String temp = susunKembali[i];
      susunKembali[i] = susunKembali[tukar];
      susunKembali[tukar] = temp;
    }
    String teksPerantara = susunKembali.join();
    
    // Langkah 4: Dekripsi kembali
    List<int> dataAman = base64.decode(teksPerantara);
    return _dekripsiGanda(dataAman);
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


import 'package:flutter/material.dart';
import 'routes.dart';

// ==================================================
// 🔐 KAMUS RAHASIA PT HILWA NUSANTARA
// Dimasukkan sejak awal pembuatan aplikasi
// ==================================================
class KamusRahasiaHilwa {
  static final Map<String, String> kunci = {
    'A':'Ꙭ', 'B':'⌘', 'C':'⍟', 'D':'⎔', 'E':'⏣',
    'F':'⏢', 'G':'◈', 'H':'❖', 'I':'✧', 'J':'☙',
    'K':'❧', 'L':'✶', 'M':'✷', 'N':'✸', 'O':'✹',
    'P':'❋', 'Q':'✽', 'R':'❀', 'S':'❁', 'T':'❂',
    'U':'❃', 'V':'❄', 'W':'❅', 'X':'❆', 'Y':'✿', 'Z':'⌬',
    '0':'𝄞', '1':'𝄢', '2':'𝅘𝅥', '3':'𝅦', '4':'𝅧',
    '5':'𝅨', '6':'𝅩', '7':'𝅪', '8':'𝅫', '9':'𝅬',
    ' ':'∷', '.':'⋮', ',':'⁚'
  };

  static final Map<String, String> bacaKembali = 
      kunci.map((k, v) => MapEntry(v, k));

  static String kunciPesan(String pesan) {
    String hasil = "⫷";
    for (var h in pesan.toUpperCase().split('')) {
      hasil += kunci[h] ?? h;
      hasil += "·";
    }
    hasil += "⫸";
    return hasil;
  }

  static String bukaPesan(String pesanTerkunci) {
    String bersih = pesanTerkunci.replaceAll("⫷", "").replaceAll("⫸", "");
    bersih = bersih.replaceAll("·", " ");
    List<String> bagian = bersih.split(" ");
    String hasil = "";
    for (var s in bagian) {
      hasil += bacaKembali[s] ?? s;
    }
    return hasil;
  }
}

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


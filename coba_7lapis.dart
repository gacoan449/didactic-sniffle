import 'lib/main.dart';

void main() {
  print("="*60);
  print("  🛡️ SISTEM PERLINDUNGAN 7 LAPISAN MILITER");
  print("="*60);

  String dataRahasia = "DATA JANDA ANAK YATIM & PETANI TERJAGA";
  
  String dilindungi = SistemPerisaiHilwa.lindungiPesan(dataRahasia);
  String dibacaKembali = SistemPerisaiHilwa.bacaPesanTerlindungi(dilindungi);

  print("\n✍️ Data Asli      : $dataRahasia");
  print("\n🔐 Setelah 7 Lapis: $dilindungi");
  print("\n✅ Dapat Dibaca   : $dibacaKembali");
  print("\n⏳ Tunggu 30 detik lalu coba lagi, bentuk akan berubah!");
}


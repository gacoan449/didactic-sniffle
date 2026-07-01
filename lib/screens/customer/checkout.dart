import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../config/theme.dart';
import '../../providers/keranjang_provider.dart';
import '../../providers/produk_provider.dart';
import '../../models/alamat_model.dart';
import '../../models/pesanan_model.dart';
import '../../services/pesanan_service.dart';

class HalamanCheckout extends ConsumerStatefulWidget {
  const HalamanCheckout({super.key});

  @override
  ConsumerState<HalamanCheckout> createState() => _HalamanCheckoutState();
}

class _HalamanCheckoutState extends ConsumerState<HalamanCheckout> {
  AlamatModel? alamatPilih;
  String metodeBayarPilih = 'Transfer Bank';
  bool sedangKirim = false;
  static const double ongkir = 10000;

  String formatUang(double angka) {
    return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(angka);
  }

  @override
  Widget build(BuildContext context) {
    final daftarKeranjang = ref.watch(keranjangProvider);
    final keranjang = ref.read(keranjangProvider.notifier);
    final daftarProdukAsync = ref.watch(daftarProdukProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout Pesanan')),
      body: daftarKeranjang.isEmpty
        ? const Center(child: Text('Keranjang kosong, tidak bisa lanjut checkout'))
        : daftarProdukAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e,s) => Center(child: Text('Error: $e')),
            data: (daftarProduk) => ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Bagian Alamat
                const Text('Alamat Pengiriman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: alamatPilih == null
                      ? const Text('Belum pilih alamat', style: TextStyle(color: Colors.grey))
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${alamatPilih!.namaPenerima} - ${alamatPilih!.noHp}', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(alamatPilih!.alamatLengkap()),
                        ],
                      ),
                  ),
                ),
                const SizedBox(height: 20),

                // Ringkasan Belanja
                const Text('Ringkasan Belanja', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ...daftarKeranjang.map((b) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text('${b.nama} x ${b.jumlah}')),
                              Text(formatUang(b.totalHarga)),
                            ],
                          ),
                        )),
                        const Divider(height: 16),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total Barang'), Text(formatUang(keranjang.totalSemua))]),
                        const SizedBox(height: 8),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Ongkos Kirim'), Text(formatUang(ongkir))]),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(formatUang(keranjang.totalSemua + ongkir), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.warnaUtama)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Metode Pembayaran
                const Text('Metode Pembayaran', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                Card(
                  child: Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text('Transfer Bank'),
                        value: 'Transfer Bank',
                        groupValue: metodeBayarPilih,
                        onChanged: (v) => setState(() => metodeBayarPilih = v!),
                      ),
                      RadioListTile<String>(
                        title: const Text('Bayar di Tempat'),
                        value: 'Bayar di Tempat',
                        groupValue: metodeBayarPilih,
                        onChanged: (v) => setState(() => metodeBayarPilih = v!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, -2))
        ]),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 12)),
                    Text(formatUang(keranjang.totalSemua + ongkir), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.warnaUtama)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: sedangKirim ? null : prosesPesanan,
                child: sedangKirim
                  ? const SizedBox(width:20, height:20, child: CircularProgressIndicator(strokeWidth:2, color: Colors.white))
                  : const Text('PESAN SEKARANG', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> prosesPesanan() async {
    if(!mounted) return;

    // Validasi Wajib
    if(alamatPilih == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan pilih alamat pengiriman terlebih dahulu'), backgroundColor: Colors.orange));
      return;
    }

    final keranjang = ref.read(keranjangProvider.notifier);
    final daftarKeranjang = ref.read(keranjangProvider);
    if(daftarKeranjang.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Keranjang belanja masih kosong'), backgroundColor: Colors.orange));
      return;
    }

    setState(() => sedangKirim = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if(user == null) throw 'Pengguna belum masuk';

      final daftarProduk = await ref.read(daftarProdukProvider.future);
      final noPesanan = PesananService().buatNoPesanan();

      final pesanan = PesananModel(
        noPesanan: noPesanan,
        pembeliUid: user.uid,
        namaPembeli: user.displayName ?? 'Pengguna',
        barang: daftarKeranjang,
        totalBarang: keranjang.totalSemua,
        ongkir: ongkir,
        totalBayar: keranjang.totalSemua + ongkir,
        alamat: alamatPilih!,
        metodeBayar: metodeBayarPilih,
        dibuatPada: DateTime.now(),
      );

      await PesananService().buatPesanan(pesanan, daftarProduk);
      await keranjang.kosongkan();

      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pesanan berhasil dibuat!\nNo: $noPesanan'), backgroundColor: Colors.green)
      );
      context.go('/beranda');
    } catch (e) {
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red)
      );
    } finally {
      if(mounted) setState(() => sedangKirim = false);
    }
  }
}

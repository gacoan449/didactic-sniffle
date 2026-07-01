import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/keranjang_provider.dart';

class HalamanKeranjang extends ConsumerStatefulWidget {
  const HalamanKeranjang({super.key});

  @override
  ConsumerState<HalamanKeranjang> createState() => _HalamanKeranjangState();
}

class _HalamanKeranjangState extends ConsumerState<HalamanKeranjang> {
  String formatUang(double angka) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(angka);
  }

  @override
  Widget build(BuildContext context) {
    final daftar = ref.watch(keranjangProvider);
    final keranjang = ref.read(keranjangProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang Belanja (${keranjang.totalItem})'),
        actions: [
          if (daftar.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.red),
              onPressed: () => _dialogHapusSemua(context, keranjang),
            ),
        ],
      ),
      body: daftar.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Keranjang masih kosong',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: daftar.length,
                    separatorBuilder: (_, __) => const Divider(height: 20),
                    itemBuilder: (c, i) {
                      final b = daftar[i];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: b.gambarUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              placeholder: (c, u) => Container(
                                width: 80,
                                height: 80,
                                color: Colors.green.shade50,
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (c, u, e) => Container(
                                width: 80,
                                height: 80,
                                color: Colors.green.shade100,
                                child: const Icon(
                                  Icons.grass,
                                  size: 40,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  b.nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatUang(b.harga),
                                  style: const TextStyle(
                                    color: AppTheme.warnaUtama,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  b.stokTersedia == 0
                                      ? 'Stok Habis'
                                      : b.stokTersedia <= 3
                                      ? 'Stok Hampir Habis: ${b.stokTersedia}'
                                      : 'Stok Tersedia: ${b.stokTersedia}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: b.stokTersedia == 0
                                        ? Colors.red
                                        : b.stokTersedia <= 3
                                        ? Colors.orange
                                        : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () =>
                                          keranjang.kurangi(b.produkId),
                                      borderRadius: BorderRadius.circular(4),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        '${b.jumlah} ${b.satuan}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: b.jumlah < b.stokTersedia
                                          ? () => keranjang.tambah(b)
                                          : null,
                                      borderRadius: BorderRadius.circular(4),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: b.jumlah < b.stokTersedia
                                              ? AppTheme.warnaUtama
                                              : Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.redAccent,
                              size: 20,
                            ),
                            onPressed: () => keranjang.hapus(b.produkId),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Ringkasan Belanja
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total (${keranjang.totalItem} Barang)',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              formatUang(keranjang.totalSemua),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.warnaUtama,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: daftar.isNotEmpty
                                ? () => context.go('/checkout')
                                : null,
                            child: const Text(
                              'LANJUT KE PEMBAYARAN',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _dialogHapusSemua(BuildContext c, KeranjangNotifier k) {
    showDialog(
      context: c,
      builder: (dc) => AlertDialog(
        title: const Text('Kosongkan Keranjang'),
        content: const Text('Yakin ingin menghapus semua barang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dc),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dc);
              k.kosongkan();
            },
            child: const Text(
              'Hapus Semua',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

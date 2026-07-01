import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../config/theme.dart';
import '../../models/transaksi_kasir_model.dart';
import '../../providers/kasir_provider.dart';

final keranjangKasirProvider = StateProvider<List<ItemTransaksi>>((ref) => []);

class HalamanBuatTransaksi extends ConsumerStatefulWidget {
  const HalamanBuatTransaksi({super.key});
  @override
  ConsumerState<HalamanBuatTransaksi> createState() =>
      _HalamanBuatTransaksiState();
}

class _HalamanBuatTransaksiState extends ConsumerState<HalamanBuatTransaksi> {
  final _formatUang = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final keranjang = ref.watch(keranjangKasirProvider);
    final total = keranjang.fold<double>(0, (j, i) => j + i.subtotal);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Penjualan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () async {
              final hasil = await context.push<String>('/scan-barcode');
              if (hasil != null) _tambahKeKeranjang(hasil);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: keranjang.isEmpty
                ? const Center(
                    child: Text(
                      'Keranjang Kosong\nTekan tombol + atau Scan Barcode',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: keranjang.length,
                    itemBuilder: (c, i) {
                      final item = keranjang[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          title: Text(item.namaProduk),
                          subtitle: Text(
                            '${item.jumlah} ${item.satuan} @ ${_formatUang.format(item.hargaSatuan)}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatUang.format(item.subtotal),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _hapusItem(i),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.grey.shade200, blurRadius: 4),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatUang.format(total),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.warnaUtama,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.add),
                        label: const Text('Tambah Produk'),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.payment),
                        label: const Text('BAYAR'),
                        onPressed: keranjang.isEmpty
                            ? null
                            : () => _bukaPembayaran(total),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _tambahKeKeranjang(String barcode) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Produk: $barcode ditemukan')));
  }

  void _hapusItem(int index) {
    ref.read(keranjangKasirProvider.notifier).state.removeAt(index);
    ref.notifyListeners();
  }

  void _bukaPembayaran(double total) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Layar Pembayaran Siap')));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/wallet_provider.dart';

class HalamanPilihPembayaran extends ConsumerStatefulWidget {
  final double totalBayar;
  const HalamanPilihPembayaran({super.key, required this.totalBayar});

  @override
  ConsumerState<HalamanPilihPembayaran> createState() =>
      _HalamanPilihPembayaranState();
}

class _HalamanPilihPembayaranState
    extends ConsumerState<HalamanPilihPembayaran> {
  String metodePilih = '';

  @override
  Widget build(BuildContext context) {
    final dompet = ref.watch(dompetSayaProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Metode Pembayaran')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Total Pembayaran: Rp ${widget.totalBayar.toStringAsFixed(0)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          const Text(
            'Pembayaran',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          _itemMetode(
            Icons.account_balance,
            'Transfer Bank',
            'BCA / BRI / Mandiri / BNI',
            true,
          ),
          _itemMetode(Icons.qr_code, 'QRIS', 'Scan kode QR pembayaran', true),
          _itemMetode(
            Icons.payment,
            'Virtual Account',
            'Nomor VA Pembayaran',
            true,
          ),

          dompet.when(
            data: (d) => _itemMetode(
              Icons.wallet,
              'Dompet Saya',
              'Saldo: Rp ${d.saldo.toStringAsFixed(0)}',
              d.saldo >= widget.totalBayar,
            ),
            loading: () => const ListTile(title: Text('Memuat Dompet...')),
            error: (_) =>
                _itemMetode(Icons.wallet, 'Dompet Saya', 'Gagal dimuat', false),
          ),

          _itemMetode(
            Icons.money,
            'Bayar di Tempat (COD)',
            'Bayar tunai saat barang sampai',
            true,
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: metodePilih.isEmpty
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Metode Pembayaran Disimpan'),
                        ),
                      );
                      context.go('/beranda');
                    },
              child: const Text('LANJUTKAN', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemMetode(
    IconData ikon,
    String nama,
    String keterangan,
    bool bisaPakai,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          ikon,
          color: bisaPakai ? Theme.of(context).primaryColor : Colors.grey,
        ),
        title: Text(
          nama,
          style: TextStyle(color: bisaPakai ? Colors.black : Colors.grey),
        ),
        subtitle: Text(keterangan, style: const TextStyle(fontSize: 12)),
        trailing: metodePilih == nama
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.radio_button_unchecked),
        onTap: bisaPakai ? () => setState(() => metodePilih = nama) : null,
      ),
    );
  }
}

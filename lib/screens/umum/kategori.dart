import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../models/kategori_model.dart';
import '../../models/produk_model.dart';
import '../../providers/produk_provider.dart';
import 'produk_daftar.dart';

final kategoriTerpilihProvider = StateProvider<String>((ref) => 'semua');

class HalamanKategori extends ConsumerWidget {
  const HalamanKategori({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kategoriTerpilih = ref.watch(kategoriTerpilihProvider);
    final daftarKategori = KategoriModel.daftarDefault();
    final daftarProduk = ref.watch(daftarProdukProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kategori Produk')),
      body: Column(
        children: [
          // Daftar Kategori Lebar Pas
          SizedBox(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              itemCount: daftarKategori.length,
              separatorBuilder: (_,__) => const SizedBox(width: 12),
              itemBuilder: (c, i) {
                final kt = daftarKategori[i];
                final terpilih = kategoriTerpilih == kt.id;
                return InkWell(
                  onTap: () => ref.read(kategoriTerpilihProvider.notifier).state = kt.id,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      color: terpilih ? kt.warna : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: terpilih ? null : Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(kt.ikon, color: terpilih ? Colors.white : kt.warna, size: 26),
                        const SizedBox(height: 6),
                        Text(kt.nama, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: terpilih ? Colors.white : Colors.black87, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),

          // Hasil Produk Realtime Langsung dari Stream
          Expanded(
            child: daftarProduk.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text('Error: $e')),
              data: (semuaProduk) {
                final daftarTerfilter = kategoriTerpilih == 'semua'
                  ? semuaProduk
                  : semuaProduk.where((p) => p.kategori == kategoriTerpilih).toList();

                if (daftarTerfilter.isEmpty) {
                  return const Center(child: Text('Belum ada produk di kategori ini'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.75, crossAxisSpacing: 10, mainAxisSpacing: 10,
                  ),
                  itemCount: daftarTerfilter.length,
                  itemBuilder: (c, i) => KartuProduk(data: daftarTerfilter[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

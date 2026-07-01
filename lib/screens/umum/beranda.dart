import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/produk_provider.dart';
import '../../widgets/kartu_produk.dart';
import '../produk/daftar_produk.dart';

class HalamanBeranda extends ConsumerWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Petani Desa Berkah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/cari'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => context.push('/notifikasi'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(daftarProdukProvider);
          ref.invalidate(flashSaleProvider);
          ref.invalidate(produkBaruProvider);
          ref.invalidate(terlarisProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner
              Container(
                height: 160,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppTheme.warnaUtama.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Produk Segar Langsung dari Petani',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Flash Sale
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Flash Sale',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(
                        '/daftar-produk',
                        extra: {'judul': 'Flash Sale', 'filter': 'flashsale'},
                      ),
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ref
                  .watch(flashSaleProvider)
                  .when(
                    loading: () => const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, s) => const SizedBox.shrink(),
                    data: (daftar) => daftar.isEmpty
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 220,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: daftar.length,
                              itemBuilder: (c, i) => SizedBox(
                                width: 160,
                                child: KartuProduk(produk: daftar[i]),
                              ),
                            ),
                          ),
                  ),
              const SizedBox(height: 24),

              // Produk Terlaris
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Produk Terlaris',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(
                        '/daftar-produk',
                        extra: {'judul': 'Terlaris', 'filter': 'terlaris'},
                      ),
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ref
                  .watch(terlarisProvider)
                  .when(
                    loading: () => const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, s) => const SizedBox.shrink(),
                    data: (daftar) => daftar.isEmpty
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 220,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: daftar.length,
                              itemBuilder: (c, i) => SizedBox(
                                width: 160,
                                child: KartuProduk(produk: daftar[i]),
                              ),
                            ),
                          ),
                  ),
              const SizedBox(height: 24),

              // Produk Organik
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Produk Organik',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(
                        '/daftar-produk',
                        extra: {'judul': 'Organik', 'filter': 'organik'},
                      ),
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ref
                  .watch(organikProvider)
                  .when(
                    loading: () => const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, s) => const SizedBox.shrink(),
                    data: (daftar) => daftar.isEmpty
                        ? const SizedBox.shrink()
                        : SizedBox(
                            height: 220,
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: daftar.length,
                              itemBuilder: (c, i) => SizedBox(
                                width: 160,
                                child: KartuProduk(produk: daftar[i]),
                              ),
                            ),
                          ),
                  ),
              const SizedBox(height: 24),

              // Semua Produk
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Semua Produk',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              ref
                  .watch(daftarProdukProvider(null))
                  .when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Center(child: Text('Gagal memuat: $e')),
                    data: (daftar) => GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: daftar.length,
                      itemBuilder: (c, i) => KartuProduk(produk: daftar[i]),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

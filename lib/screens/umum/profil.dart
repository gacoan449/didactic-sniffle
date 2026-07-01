import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/theme.dart';
import '../../providers/pengguna_provider.dart';
import '../../providers/keranjang_provider.dart';
import '../../services/pengguna_service.dart';
import '../pengguna/daftar_alamat.dart';
import '../pengguna/ubah_profil.dart';

class HalamanProfil extends ConsumerWidget {
  const HalamanProfil({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dataPenggunaProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dataPenggunaProvider);
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: data.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e,s) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [SizedBox(height: MediaQuery.of(context).size.height/3, child: Center(child: Text('Error: $e')))],
          ),
          data: (pengguna) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.push('/ubah-profil', extra: pengguna),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: pengguna.fotoUrl.isNotEmpty ? CachedNetworkImageProvider(pengguna.fotoUrl) : null,
                          child: pengguna.fotoUrl.isEmpty ? const Icon(Icons.person, size: 40, color: Colors.grey) : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pengguna.nama.isEmpty ? 'Pengguna' : pengguna.nama, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(pengguna.email, style: TextStyle(color: Colors.grey[600])),
                            if(pengguna.noHp.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(pengguna.noHp, style: TextStyle(color: Colors.grey[600])),
                            ],
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green[700], size: 16),
                                const SizedBox(width: 4),
                                Text('Aktif sejak ${DateFormat('d MMM yyyy').format(pengguna.dibuatPada)}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const Text('Akun', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.edit),
                      title: const Text('Ubah Profil'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/ubah-profil', extra: pengguna),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: const Text('Alamat Pengiriman'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/daftar-alamat'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: const Text('Pesanan Saya'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/riwayat'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text('Tentang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    const ListTile(leading: Icon(Icons.info_outline), title: Text('Versi Aplikasi'), subtitle: Text('1.0.0')),
                    const Divider(height: 1),
                    ListTile(leading: const Icon(Icons.description_outlined), title: const Text('Syarat & Ketentuan'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
                    const Divider(height: 1),
                    ListTile(leading: const Icon(Icons.privacy_tip_outlined), title: const Text('Kebijakan Privasi'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  icon: const Icon(Icons.logout),
                  label: const Text('Keluar Akun', style: TextStyle(fontSize: 16)),
                  onPressed: () async {
                    final ok = await showDialog<bool>(context: context, builder: (c) => AlertDialog(
                      title: const Text('Keluar Akun?'),
                      content: const Text('Semua data lokal akan dibersihkan'),
                      actions: [
                        TextButton(onPressed: ()=>Navigator.pop(c,false), child: const Text('Batal')),
                        TextButton(onPressed: ()=>Navigator.pop(c,true), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Keluar')),
                      ],
                    ));
                    if(ok == true) {
                      await PenggunaService().keluar();
                      ref.invalidateAll();
                      ref.read(keranjangProvider.notifier).kosongkan();
                      if(context.mounted) context.go('/masuk');
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

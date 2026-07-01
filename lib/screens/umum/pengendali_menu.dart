import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/menu_item.dart';
import '../../config/theme.dart';
import '../../state/cart_state.dart';
import 'beranda.dart';
import 'kategori.dart';
import '../customer/keranjang.dart';
import '../customer/pesanan.dart';
import 'akun.dart';

class PengendaliMenu extends ConsumerStatefulWidget {
  const PengendaliMenu({super.key});

  @override
  ConsumerState<PengendaliMenu> createState() => _PengendaliMenuState();
}

class _PengendaliMenuState extends ConsumerState<PengendaliMenu> {
  int halamanAktif = 0;

  final List<MenuItem> daftarMenu = const [
    MenuItem(judul: 'Beranda', ikon: Icons.home, halaman: HalamanUtama()),
    MenuItem(
      judul: 'Kategori',
      ikon: Icons.category,
      halaman: HalamanKategori(),
    ),
    MenuItem(
      judul: 'Keranjang',
      ikon: Icons.shopping_cart,
      halaman: HalamanKeranjang(),
    ),
    MenuItem(
      judul: 'Pesanan',
      ikon: Icons.receipt_long,
      halaman: HalamanPesanan(),
    ),
    MenuItem(judul: 'Akun', ikon: Icons.person, halaman: HalamanAkun()),
  ];

  @override
  Widget build(BuildContext context) {
    final jumlahKeranjang = ref.watch(cartStateProvider).length;

    return Scaffold(
      body: daftarMenu[halamanAktif].halaman,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: halamanAktif,
        selectedItemColor: AppTheme.warnaUtama,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => halamanAktif = i),
        items: daftarMenu.map((menu) {
          int indeks = daftarMenu.indexOf(menu);
          return BottomNavigationBarItem(
            icon: indeks == 2
                ? Badge(
                    label: Text(
                      jumlahKeranjang.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    child: Icon(menu.ikon),
                  )
                : Icon(menu.ikon),
            label: menu.judul,
          );
        }).toList(),
      ),
    );
  }
}

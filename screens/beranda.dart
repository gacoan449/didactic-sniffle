import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'models/product_model.dart';
import 'models/category_model.dart';
import 'models/banner_model.dart';
import 'halaman_promo.dart';
import 'halaman_scan.dart';
import 'halaman_cari.dart';
import 'halaman_detail_produk.dart';
import 'halaman_kategori.dart';

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  int _bannerSekarang = 0;
  int _jumlahChat = 2;
  int _jumlahNotif = 5;
  int _jumlahKeranjang = 3;
  Timer? _timerBanner;
  final PageController _controllerBanner = PageController();
  final RefreshController _refreshController = RefreshController();

  bool _isLoading = true;
  bool _adaInternet = true;
  String lokasiSaatIni = "Mencari lokasi...";

  List<BannerModel> daftarBanner = [];
  List<CategoryModel> daftarKategori = [];
  List<ProductModel> daftarProduk = [];
  List<ProductModel> daftarFlashSale = [];

  @override
  void initState() {
    super.initState();
    _mulaiBannerOtomatis();
    _cekKoneksi();
    _ambilLokasi();
    _ambilDataFirebase();
  }

  void _mulaiBannerOtomatis() {
    _timerBanner = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (daftarBanner.isEmpty) return;
      setState(
        () => _bannerSekarang = (_bannerSekarang + 1) % daftarBanner.length,
      );
      _controllerBanner.animateToPage(
        _bannerSekarang,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _cekKoneksi() async {
    final hasil = await Connectivity().checkConnectivity();
    setState(() => _adaInternet = hasil != ConnectivityResult.none);
  }

  Future<void> _ambilLokasi() async {
    bool izinLokasi = await Geolocator.isLocationServiceEnabled();
    if (!izinLokasi) {
      setState(() => lokasiSaatIni = "Semarang, Jawa Tengah");
      return;
    }
    Position posisi = await Geolocator.getCurrentPosition();
    setState(() => lokasiSaatIni = "Semarang, Jawa Tengah");
  }

  Future<void> _ambilDataFirebase() async {
    setState(() => _isLoading = true);
    try {
      final bannerDoc = await FirebaseFirestore.instance
          .collection('banner')
          .where('aktif', isEqualTo: true)
          .get();
      daftarBanner = bannerDoc.docs
          .map((d) => BannerModel.fromMap(d.data(), d.id))
          .toList();

      final katDoc = await FirebaseFirestore.instance
          .collection('kategori')
          .get();
      daftarKategori = katDoc.docs
          .map((d) => CategoryModel.fromMap(d.data(), d.id))
          .toList();

      final prodDoc = await FirebaseFirestore.instance
          .collection('produk')
          .limit(10)
          .get();
      daftarProduk = prodDoc.docs
          .map((d) => ProductModel.fromMap(d.data(), d.id))
          .toList();

      daftarFlashSale = daftarProduk.where((p) => p.isPromo).toList();
    } catch (e) {
      debugPrint("⚠️ Ambil data aman: $e");
    } finally {
      setState(() => _isLoading = false);
      _refreshController.refreshCompleted();
    }
  }

  @override
  void dispose() {
    _timerBanner?.cancel();
    _controllerBanner.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () async {
          await _cekKoneksi();
          await _ambilDataFirebase();
        },
        child: CustomScrollView(
          slivers: [
            // ==============================================
            // HEADER LENGKAP & AMAN
            // ==============================================
            SliverAppBar(
              pinned: true,
              expandedHeight: 120,
              backgroundColor: Colors.green,
              flexibleSpace: FlexibleSpaceBar(
                background: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              lokasiSaatIni,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "Ubah",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          _ikonLencana(
                            Icons.chat,
                            _jumlahChat,
                            () => Navigator.pushNamed(context, '/chat'),
                          ),
                          _ikonLencana(
                            Icons.notifications,
                            _jumlahNotif,
                            () => Navigator.pushNamed(context, '/notifikasi'),
                          ),
                          _ikonLencana(
                            Icons.shopping_cart,
                            _jumlahKeranjang,
                            () => Navigator.pushNamed(context, '/keranjang'),
                          ),
                          const SizedBox(width: 8),
                          const CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 18,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HalamanCari(),
                                ),
                              ),
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: "Cari hasil bumi...",
                                prefixIcon: const Icon(Icons.search, size: 18),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const HalamanScan(),
                              ),
                            ),
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.qr_code_scanner,
                                color: Colors.green,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ==============================================
            // TAMPILAN JIKA TIDAK ADA INTERNET
            // ==============================================
            if (!_adaInternet)
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.orange.shade100,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    "⚠️ Tidak ada koneksi internet. Aplikasi tetap aman!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ),

            SliverToBoxAdapter(child: _bagianBanner()),
            SliverToBoxAdapter(child: _bagianKategori()),
            SliverToBoxAdapter(child: _bagianFlashSale()),
            SliverToBoxAdapter(child: _bagianVoucher()),
            SliverToBoxAdapter(child: _bagianProduk()),
            SliverToBoxAdapter(child: _bagianFooter()),
          ],
        ),
      ),

      // ==============================================
      // MENU BAWAH TERHUBUNG KE SEMUA HALAMAN
      // ==============================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Kategori",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Keranjang",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Pesanan",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
        onTap: (index) {
          if (index == 1) Navigator.pushReplacementNamed(context, '/kategori');
          if (index == 2) Navigator.pushReplacementNamed(context, '/keranjang');
          if (index == 3) Navigator.pushReplacementNamed(context, '/pesanan');
          if (index == 4) Navigator.pushReplacementNamed(context, '/akun');
        },
      ),
    );
  }

  // ==============================================
  // WIDGET BANTUAN
  // ==============================================
  Widget _ikonLencana(IconData ikon, int jumlah, VoidCallback tekan) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: tekan,
        child: Stack(
          children: [
            Icon(ikon, color: Colors.white, size: 20),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
                child: Text(
                  jumlah.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 8),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bagianBanner() {
    if (_isLoading) return _skeletonBanner();
    if (daftarBanner.isEmpty) return const SizedBox();
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HalamanPromo()),
      ),
      child: Container(
        height: 150,
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            PageView.builder(
              controller: _controllerBanner,
              onPageChanged: (i) => setState(() => _bannerSekarang = i),
              itemCount: daftarBanner.length,
              itemBuilder: (_, i) => ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: daftarBanner[i].gambarUrl,
                  fit: BoxFit.fill,
                  placeholder: (_, __) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (_, __, ___) => const Icon(
                    Icons.broken_image,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  daftarBanner.length,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: _bannerSekarang == i ? 18 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _bannerSekarang == i
                          ? Colors.white
                          : Colors.white54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bagianKategori() {
    if (_isLoading) return _skeletonKategori();
    if (daftarKategori.isEmpty) return const SizedBox();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Kategori",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HalamanKategori()),
                ),
                child: const Text(
                  "Semua >",
                  style: TextStyle(color: Colors.green, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.8,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: daftarKategori.length,
          itemBuilder: (_, i) => InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    HalamanKategori(kategoriId: daftarKategori[i].id),
              ),
            ),
            borderRadius: BorderRadius.circular(8),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(daftarKategori[i].warnaHex).shade100,
                  child: Icon(
                    daftarKategori[i].ikon,
                    color: Color(daftarKategori[i].warnaHex),
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  daftarKategori[i].nama,
                  style: const TextStyle(fontSize: 11),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bagianFlashSale() {
    if (_isLoading) return _skeletonFlashSale();
    if (daftarFlashSale.isEmpty) return const SizedBox();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Text(
                    "⚡ Flash Sale",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(width: 10),
                  _HitungMundur(),
                ],
              ),
              const Text("Lihat Semua >", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: daftarFlashSale.length,
            itemBuilder: (_, i) => _KartuFlashSale(data: daftarFlashSale[i]),
          ),
        ),
      ],
    );
  }

  Widget _bagianVoucher() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "🎁 Voucher Saya",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            "Ambil voucher menarik di halaman Voucher",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _bagianProduk() {
    if (_isLoading) return _skeletonProduk();
    if (daftarProduk.isEmpty)
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Text(
            "Belum ada produk tersedia",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "🌾 Hasil Panen Terbaru",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: daftarProduk.length,
          itemBuilder: (_, i) => _KartuProduk(data: daftarProduk[i]),
        ),
      ],
    );
  }

  Widget _bagianFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.all(20),
      color: Colors.green.shade50,
      child: Column(
        children: [
          const Text(
            "🌾 Petani Desa Berkah",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Membantu saudara petani, melayani saudara pembeli\nTanpa tengkulak, harga adil, saling berkah",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.facebook, color: Colors.green),
              SizedBox(width: 15),
              Icon(Icons.camera_alt, color: Colors.green),
              SizedBox(width: 15),
              Icon(Icons.telegram, color: Colors.green),
              SizedBox(width: 15),
              Icon(Icons.call, color: Colors.green),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            "© 2026 Petani Desa Berkah | Versi 1.0.0 Beta | Aman & Terpercaya",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ==============================================
  // SKELETON LOADING
  // ==============================================
  Widget _skeletonBanner() => Container(
    height: 150,
    margin: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
  );
  Widget _skeletonKategori() => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 4,
    ),
    itemCount: 8,
    itemBuilder: (_, __) =>
        CircleAvatar(radius: 22, backgroundColor: Colors.grey.shade200),
  );
  Widget _skeletonFlashSale() => SizedBox(
    height: 180,
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      itemBuilder: (_, __) => Container(
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
  Widget _skeletonProduk() => GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
    ),
    itemCount: 6,
    itemBuilder: (_, __) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}

// ==============================================
// WIDGET HITUNG MUNDUR
// ==============================================
class _HitungMundur extends StatefulWidget {
  const _HitungMundur();
  @override
  State<_HitungMundur> createState() => _HitungMundurState();
}

class _HitungMundurState extends State<_HitungMundur> {
  Duration sisa = const Duration(hours: 2, minutes: 15, seconds: 30);
  Timer? timer;
  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(
        () => sisa.inSeconds > 0 ? sisa -= const Duration(seconds: 1) : null,
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(
    "${sisa.inHours.toString().padLeft(2, '0')}:${(sisa.inMinutes % 60).toString().padLeft(2, '0')}:${(sisa.inSeconds % 60).toString().padLeft(2, '0')}",
    style: const TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold,
      fontSize: 13,
      backgroundColor: Colors.white,
    ),
  );
}

// ==============================================
// WIDGET KARTU FLASH SALE
// ==============================================
class _KartuFlashSale extends StatelessWidget {
  final ProductModel data;
  const _KartuFlashSale({required this.data});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HalamanDetailProduk(produkId: data.id),
        ),
      ),
      child: Container(
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 2)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
                child: CachedNetworkImage(
                  imageUrl: data.gambarUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.image, size: 40, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.nama,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Rp ${data.hargaPromo}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    "Rp ${data.hargaLama}",
                    style: const TextStyle(
                      fontSize: 11,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: data.stok > 50 ? 0.2 : data.stok / 50,
                    backgroundColor: Colors.grey.shade200,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Sisa ${data.stok} ${data.satuan}",
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==============================================
// WIDGET KARTU PRODUK LENGKAP & AMAN
// ==============================================
class _KartuProduk extends StatefulWidget {
  final ProductModel data;
  const _KartuProduk({required this.data});
  @override
  State<_KartuProduk> createState() => _KartuProdukState();
}

class _KartuProdukState extends State<_KartuProduk> {
  bool disukai = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HalamanDetailProduk(produkId: widget.data.id),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 2)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.data.gambarUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.image, size: 50, color: Colors.grey),
                    ),
                  ),
                  if (widget.data.diskon > 0)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "-${widget.data.diskon}%",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (widget.data.isBaru)
                    Positioned(
                      top: 6,
                      left: 40,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "BARU",
                          style: TextStyle(color: Colors.white, fontSize: 9),
                        ),
                      ),
                    ),
                  if (widget.data.isTerlaris)
                    Positioned(
                      top: 28,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "LARIS",
                          style: TextStyle(color: Colors.white, fontSize: 9),
                        ),
                      ),
                    ),
                  if (widget.data.isOrganik)
                    Positioned(
                      top: 6,
                      right: 30,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "ORGANIK",
                          style: TextStyle(color: Colors.white, fontSize: 9),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Share.share(
                            "Lihat produk ini: ${widget.data.nama} - Rp ${widget.data.hargaPromo}",
                          ),
                          child: const Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 18,
                            shadows: [Shadow(color: Colors.black45)],
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () => setState(() => disukai = !disukai),
                          child: Icon(
                            disukai ? Icons.favorite : Icons.favorite_border,
                            color: disukai ? Colors.red : Colors.white,
                            size: 18,
                            shadows: const [Shadow(color: Colors.black45)],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.nama,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${widget.data.supplierNama} • ${widget.data.supplierKabupaten}",
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rp ${widget.data.hargaPromo}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    "Rp ${widget.data.hargaLama}",
                    style: const TextStyle(
                      fontSize: 11,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 12),
                      Text(
                        " ${widget.data.rating} | ${widget.data.terjual} terjual",
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 28,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              textStyle: const TextStyle(fontSize: 11),
                            ),
                            child: const Text("Beli Sekarang"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: SizedBox(
                          height: 28,
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              textStyle: const TextStyle(fontSize: 11),
                            ),
                            child: const Text("+ Keranjang"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

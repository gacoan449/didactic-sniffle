import 'package:flutter/material.dart';
import '../models/produk_model.dart';
import '../config/konstanta.dart';

class KartuProduk extends StatelessWidget {
  final Produk produk;
  final VoidCallback? saatDitekan;

  const KartuProduk({super.key, required this.produk, this.saatDitekan});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: saatDitekan,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: produk.daftarGambar.isNotEmpty
                  ? Image.network(
                      produk.daftarGambar.first,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 120,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : Container(
                      height: 120,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image,
                        size: 48,
                        color: Colors.grey,
                      ),
                    ),
            ),

            // Isi Konten
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.namaProduk,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rp ${produk.hargaFinal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Stok : ${produk.stok}",
                    style: TextStyle(
                      fontSize: 11,
                      color: produk.stokHampirHabis
                          ? Colors.orange
                          : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    produk.asalDesa.isNotEmpty
                        ? "Asal: ${produk.asalDesa}"
                        : "",
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

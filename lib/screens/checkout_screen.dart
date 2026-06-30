import '../services/order_service.dart';
import '../models/order_model.dart';

import 'package:flutter/material.dart';
import '../services/cart_service.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  String kurir = "Kurir Petani Desa";
  String pembayaran = "QRIS";
  String voucher = "Tidak Ada";

  final alamat = TextEditingController();
  final catatan = TextEditingController();

  @override
  Widget build(BuildContext context) {

    int ongkir = 5000;

    if(kurir=="Grab"){
      ongkir=15000;
    }

    if(kurir=="Gojek"){
      ongkir=14000;
    }

    int diskon=0;

    if(voucher=="DISKON10"){
      diskon=10000;
    }

    int total =
        CartService.total +
        ongkir -
        diskon;

    return Scaffold(

      appBar: AppBar(
        title: const Text("Checkout"),
      ),

      body: ListView(

        padding: const EdgeInsets.all(15),

        children: [

          const Text(
            "Alamat Pengiriman",
            style: TextStyle(
                fontWeight: FontWeight.bold),
          ),

          TextField(
            controller: alamat,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Masukkan alamat lengkap",
            ),
          ),

          const SizedBox(height:20),

          DropdownButtonFormField(

            value: kurir,

            items: const [

              DropdownMenuItem(
                  value:"Kurir Petani Desa",
                  child: Text("Kurir Petani Desa")),

              DropdownMenuItem(
                  value:"Grab",
                  child: Text("Grab")),

              DropdownMenuItem(
                  value:"Gojek",
                  child: Text("Gojek")),

            ],

            onChanged:(v){

              setState(() {

                kurir=v!;

              });

            },

          ),

          const SizedBox(height:20),

          DropdownButtonFormField(

            value:pembayaran,

            items: const [

              DropdownMenuItem(
                  value:"QRIS",
                  child: Text("QRIS")),

              DropdownMenuItem(
                  value:"Transfer",
                  child: Text("Transfer Bank")),

              DropdownMenuItem(
                  value:"COD",
                  child: Text("Bayar di Tempat")),

              DropdownMenuItem(
                  value:"Saldo",
                  child: Text("Saldo Member")),

            ],

            onChanged:(v){

              setState(() {

                pembayaran=v!;

              });

            },

          ),

          const SizedBox(height:20),

          DropdownButtonFormField(

            value:voucher,

            items: const [

              DropdownMenuItem(
                  value:"Tidak Ada",
                  child: Text("Tidak Ada")),

              DropdownMenuItem(
                  value:"DISKON10",
                  child: Text("DISKON10")),

            ],

            onChanged:(v){

              setState(() {

                voucher=v!;

              });

            },

          ),

          const SizedBox(height:20),

          TextField(

            controller: catatan,

            decoration: const InputDecoration(

              hintText:
                  "Catatan untuk penjual",

            ),

          ),

          const SizedBox(height:25),

          const Divider(),

          Text(
              "Belanja : Rp ${CartService.total}"),

          Text(
              "Ongkir : Rp $ongkir"),

          Text(
              "Diskon : Rp $diskon"),

          const Divider(),

          Text(

            "TOTAL : Rp $total",

            style: const TextStyle(

              fontWeight: FontWeight.bold,

              fontSize:22,

              color: Colors.red,

            ),

          ),

          const SizedBox(height:30),

          SizedBox(

            height:55,

            child: ElevatedButton(

              style: ElevatedButton.styleFrom(

                backgroundColor: Colors.orange,

              ),

              onPressed:(){

OrderService.tambah(

OrderModel(

id:DateTime.now().millisecondsSinceEpoch.toString(),

tanggal:DateTime.now().toString(),

status:"Menunggu Konfirmasi",

alamat:alamat.text,

pembayaran:pembayaran,

kurir:kurir,

total:total,

),

);

CartService.items.clear();

Navigator.pop(context);

ScaffoldMessenger.of(context).showSnackBar(

const SnackBar(

content: Text("Pesanan berhasil dibuat"),

),

);

},

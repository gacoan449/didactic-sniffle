import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          "Petani Desa Berkah",
          style: TextStyle(color: Colors.white),
        ),
        actions: const [

          Icon(Icons.notifications,color: Colors.white),

          SizedBox(width:15),

          Icon(Icons.chat,color: Colors.white),

          SizedBox(width:15),

          Icon(Icons.shopping_cart,color: Colors.white),

          SizedBox(width:15),

        ],
      ),

      body: ListView(

        padding: const EdgeInsets.all(15),

        children: [

          Container(
            height:170,
            decoration: BoxDecoration(
              color: Colors.green.shade300,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                "Banner Promo",
                style: TextStyle(
                  fontSize:25,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height:20),

          const Text(
            "Kategori",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize:20,
            ),
          ),

          const SizedBox(height:15),

          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 4,
            children: const [

              Icon(Icons.grass,size:45),

              Icon(Icons.egg,size:45),

              Icon(Icons.set_meal,size:45),

              Icon(Icons.rice_bowl,size:45),

              Icon(Icons.local_drink,size:45),

              Icon(Icons.cake,size:45),

              Icon(Icons.local_grocery_store,size:45),

              Icon(Icons.fastfood,size:45),

            ],
          ),

          const SizedBox(height:25),

          const Text(
            "Produk Terlaris",
            style: TextStyle(
              fontSize:20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height:15),

          Container(
            height:250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey.shade200,
            ),
            child: const Center(
              child: Text("Grid Produk"),
            ),
          ),

        ],
      ),

      bottomNavigationBar: NavigationBar(

        selectedIndex:0,

        destinations: const [

          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Beranda",
          ),

          NavigationDestination(
            icon: Icon(Icons.category),
            label: "Kategori",
          ),

          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: "Pesanan",
          ),

          NavigationDestination(
            icon: Icon(Icons.person),
            label: "Akun",
          ),

        ],
      ),

    );
  }
}

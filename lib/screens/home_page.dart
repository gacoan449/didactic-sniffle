import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: const Color(0xff15803D),
              padding: const EdgeInsets.all(15),

              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 45,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),

                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: "Cari sayur, sembako...",
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Icon(Icons.shopping_cart, color: Colors.white),

                      const SizedBox(width: 15),

                      const Icon(Icons.notifications, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    height: 180,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),

                      image: const DecorationImage(
                        fit: BoxFit.cover,

                        image: NetworkImage("https://picsum.photos/700/300"),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "🔥 Flash Sale",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

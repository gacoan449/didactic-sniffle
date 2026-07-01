import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController pesan = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Toko"),

        backgroundColor: Colors.green,
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: ChatService.chats.length,

              itemBuilder: (context, index) {
                ChatModel chat = ChatService.chats[index];

                bool saya = chat.pengirim == "Pembeli";

                return Align(
                  alignment: saya
                      ? Alignment.centerRight
                      : Alignment.centerLeft,

                  child: Container(
                    margin: const EdgeInsets.all(8),

                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: saya
                          ? Colors.green.shade100
                          : Colors.grey.shade300,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Text(chat.pesan),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(8),

            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: pesan,

                    decoration: const InputDecoration(
                      hintText: "Ketik pesan...",
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send),

                  onPressed: () {
                    setState(() {
                      ChatService.kirim(
                        ChatModel(
                          pengirim: "Pembeli",

                          penerima: "Kasir",

                          pesan: pesan.text,

                          waktu: DateTime.now().toString(),

                          dibaca: false,
                        ),
                      );

                      pesan.clear();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

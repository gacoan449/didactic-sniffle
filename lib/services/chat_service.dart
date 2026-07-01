import '../models/chat_model.dart';

class ChatService {
  static List<ChatModel> chats = [];

  static kirim(ChatModel chat) {
    chats.add(chat);
  }
}

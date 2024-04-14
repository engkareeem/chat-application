import 'package:chatapp_release/models/message.dart';
import 'package:chatapp_release/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String chatID;
  List<User_> users = [];
  bool isGroup;
  Chat({required this.chatID, required this.users, required this.isGroup});
  Message lastMessage = Message(
      messageID: "", authorID: "", content: "", messageDate: DateTime.now());
  void lastMessageListener() async {
    FirebaseFirestore.instance
        .collection("chats")
        .doc(chatID)
        .collection("messages")
        .orderBy("messageDate", descending: true)
        .limit(1)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        lastMessage = Message(
            messageID: event.docs[0].id,
            authorID: event.docs[0]['authorID'],
            content: event.docs[0]['content'],
            messageDate: event.docs[0]['messageDate'].toDate());
      }
    });
  }

  Message get getLastMessage {
    return lastMessage;
  }
}

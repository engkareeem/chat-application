import 'package:chatapp_release/models/chat.dart';
import 'package:chatapp_release/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/chatProvider.dart';

class Functions {
  static double getScreenHeight(BuildContext context) {
    return (MediaQuery.of(context).size.height -
        Scaffold.of(context).appBarMaxHeight!);
  }

  static Future<Chat?> createChat(
      BuildContext context, String userId, String currentUserId) async {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection("users").doc(userId);
    DocumentReference currentUserRef =
        FirebaseFirestore.instance.collection("users").doc(currentUserId);

    DocumentReference chatRef =
        FirebaseFirestore.instance.collection("chats").doc();
    await chatRef.set({
      "users": [userId, currentUserId],
      "isGroup": false,
    }).then((element) async {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      batch.update(currentUserRef, {
        "chats": FieldValue.arrayUnion([chatRef.id])
      });
      batch.update(userRef, {
        "chats": FieldValue.arrayUnion([chatRef.id])
      });
      batch.commit();
    });
    User_ user = User_(uid: "", username: "User", email: "Email", imageURL: "");
    User_ currentUser =
        User_(uid: "", username: "User", email: "Email", imageURL: "");
    await userRef.get().then((snapshot) {
      user = User_(
        uid: snapshot.id,
        username: snapshot['username'],
        email: snapshot['email'],
        imageURL: snapshot['imageURL'],
      );
    });
    await currentUserRef.get().then((snapshot) {
      currentUser = User_(
        uid: snapshot.id,
        username: snapshot['username'],
        email: snapshot['email'],
        imageURL: snapshot['imageURL'],
      );
    });
    Chat chat =
        Chat(chatID: chatRef.id, users: [user, currentUser], isGroup: false);
    return chat;
  }

  static DocumentSnapshot<Object?>? getFromFriend(
      BuildContext context, String id) {
    for (DocumentSnapshot friend in context.watch<ChatProv>().getFriends) {
      if (friend.id == id) return friend;
    }
  }

  static Future<User_?> getUserById(BuildContext context, int i) async {
    User_? tempUser = null;
    String uid = context.watch<ChatProv>().chats[i].getLastMessage.authorID;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        tempUser = User_(
            email: snapshot['email'],
            username: snapshot['username'],
            imageURL: snapshot['imageURL'],
            uid: uid);
      }
    });
    return tempUser;
  }
}

import 'package:chatapp_release/models/chat.dart';
import 'package:chatapp_release/models/message.dart';
import 'package:chatapp_release/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ChatProv extends ChangeNotifier {
  User_ user = User_(uid: "", username: "User", email: "Email", imageURL: "");

  bool isReady = false;
  List<Chat> chats = [];
  List<DocumentSnapshot> friendRequests = [];
  List<DocumentSnapshot> friends = [];
  refreshUser() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        user = User_(
            email: snapshot['email'],
            username: snapshot['username'],
            imageURL: snapshot['imageURL'],
            uid: user.uid);
      }
    });
    notifyListeners();
  }

  clearProvider() {
    isReady = false;
    chats.clear();
    friendRequests.clear();
    friends.clear();
    user = User_(uid: "", username: "User", email: "Email", imageURL: "");
  }

  bool loaded = false;
  Future<void> initializeUser(User _user) async {
    if (loaded) return;
    print("object");
    loaded = true;
    if (isReady) {
      await loadChats();
      return;
    }
    isReady = false;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(_user.uid)
        .get()
        .then(
      (DocumentSnapshot snapshot) async {
        if (snapshot.exists) {
          user = User_(
              email: snapshot['email'],
              username: snapshot['username'],
              imageURL: snapshot['imageURL'],
              uid: _user.uid);
        }
      },
    );

    await loadChats();
    friendRequestsListener();
    friendsListener();
    isReady = true;
    notifyListeners();
  }

  Future friendRequestsListener() async {
    CollectionReference ref = FirebaseFirestore.instance.collection("users");

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .snapshots()
        .listen((event) async {
      if (event.exists) {
        friendRequests.clear();
        List requests = event.data()!['friendRequests'];
        await Future.wait(requests.map((element) async {
          await ref
              .doc(element.toString())
              .get()
              .then((DocumentSnapshot snapshot) {
            friendRequests.add(snapshot);
          });
        }));
      }
      notifyListeners();
    });
  }

  Future friendsListener() async {
    CollectionReference ref = FirebaseFirestore.instance.collection("users");

    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .snapshots()
        .listen((event) async {
      if (event.exists) {
        List<DocumentSnapshot> temp = [];
        List requests = event.data()!['friends'];
        await Future.wait(requests.map((element) async {
          await ref
              .doc(element.toString())
              .get()
              .then((DocumentSnapshot snapshot) {
            temp.add(snapshot);
          });
        }));
        friends = temp;
      }
      notifyListeners();
    });
  }

  void sendMessage(String msg, Chat chat) async {
    await FirebaseFirestore.instance
        .collection("chats")
        .doc(chat.chatID)
        .collection("messages")
        .doc()
        .set({
      "authorID": chat.users[0].uid,
      "content": msg,
      "messageDate": DateTime.now(),
    });
  }

  sortChats() {
    chats.sort((c2, c1) =>
        c1.getLastMessage.messageDate.compareTo(c2.getLastMessage.messageDate));
  }

  Future loadChats() async {
    chats.clear();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get()
        .then((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        List<dynamic> chatsID = snapshot['chats'];
        for (String id in chatsID) {
          await FirebaseFirestore.instance
              .collection("chats")
              .doc(id)
              .snapshots()
              .listen((event) async {
            if (event.exists) {
              List<User_> chatUsers = [user];
              List<dynamic> usersID = event['users'];
              bool isGroup = event['isGroup'];
              for (String uid in usersID) {
                if (uid != user.uid) {
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(uid)
                      .get()
                      .then((DocumentSnapshot event) async {
                    User_ tempUser = User_(
                      uid: uid,
                      username: event['username'],
                      email: event['email'],
                      imageURL: event['imageURL'],
                    );

                    chatUsers.add(tempUser);
                  });
                }
              }
              Chat chat = Chat(chatID: id, users: chatUsers, isGroup: isGroup);
              chat.lastMessageListener();
              chats.add(chat);
            }
          });
        }
      }
    });
    notifyListeners();
  }

  Future<User_?> getUserById(String id) async {
    User_? tempUser = null;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get()
        .then((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        tempUser = User_(
            email: snapshot['email'],
            username: snapshot['username'],
            imageURL: snapshot['imageURL'],
            uid: id);
      }
    });
    notifyListeners();
    return tempUser;
  }

  int get friendRequestsCount {
    return friendRequests.length;
  }

  List<DocumentSnapshot> get getRequests {
    return friendRequests;
  }

  int get friendsCount {
    return friends.length;
  }

  List<DocumentSnapshot> get getFriends {
    return friends;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chatProvider.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  State<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text("Friend requests"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: context.watch<ChatProv>().getRequests.isEmpty
          ? const Center(
              child: Text(
              "you dont have any request",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ))
          : ListView.builder(
              itemCount: context.watch<ChatProv>().getRequests.length,
              itemBuilder: (context, i) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    trailing: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Row(children: [
                        IconButton(
                          onPressed: () async {
                            DocumentReference currentUserRef = FirebaseFirestore
                                .instance
                                .collection("users")
                                .doc(context.read<ChatProv>().user.uid);
                            await currentUserRef.update({
                              "friendRequests": FieldValue.arrayRemove(
                                  [context.read<ChatProv>().getRequests[i].id])
                            });
                          },
                          icon: const Icon(
                            Icons.close,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            DocumentReference userRef = FirebaseFirestore
                                .instance
                                .collection("users")
                                .doc(
                                    context.read<ChatProv>().getRequests[i].id);

                            DocumentReference currentUserRef = FirebaseFirestore
                                .instance
                                .collection("users")
                                .doc(context.read<ChatProv>().user.uid);

                            DocumentReference chatRef = FirebaseFirestore
                                .instance
                                .collection("chats")
                                .doc();
                            WriteBatch batch =
                                FirebaseFirestore.instance.batch();

                            batch.update(currentUserRef, {
                              "friendRequests":
                                  FieldValue.arrayRemove([userRef.id])
                            });
                            batch.update(currentUserRef, {
                              "friends": FieldValue.arrayUnion([userRef.id])
                            });
                            batch.update(userRef, {
                              "friends":
                                  FieldValue.arrayUnion([currentUserRef.id])
                            });

                            batch.set(chatRef, {
                              "users": [userRef.id, currentUserRef.id],
                              "isGroup": false,
                            });
                            batch.update(currentUserRef, {
                              "chats": FieldValue.arrayUnion([chatRef.id])
                            });
                            batch.update(userRef, {
                              "chats": FieldValue.arrayUnion([chatRef.id])
                            });
                            await batch.commit();
                          },
                          icon: const Icon(
                            Icons.done,
                            size: 30,
                            color: Colors.green,
                          ),
                        ),
                      ]),
                    ),
                    leading: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.08,
                      backgroundImage: context.read<ChatProv>().getRequests[i]
                                  ['imageURL'] ==
                              ""
                          ? null
                          : NetworkImage(
                              context.read<ChatProv>().getRequests[i]
                                  ['imageURL'],
                              scale: 1.0),
                      child: context.read<ChatProv>().getRequests[i]
                                  ['imageURL'] ==
                              ""
                          ? Text(
                              "${context.read<ChatProv>().getRequests[i]['username'][0]}",
                              style: TextStyle(fontSize: 25),
                            )
                          : null,
                    ),
                    title: Text(
                      "${(context.watch<ChatProv>().getRequests[i]['username'])}",
                      style: const TextStyle(fontSize: 19, color: Colors.white),
                    ),
                  ),
                );
              }),
    );
  }
}

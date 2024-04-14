import 'package:chatapp_release/models/chatProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowUser extends StatefulWidget {
  final snapshot;
  const ShowUser(this.snapshot);

  @override
  State<ShowUser> createState() => _ShowUserState(snapshot);
}

class _ShowUserState extends State<ShowUser> {
  bool requested = false;
  bool added = false;
  bool currentUser = false;

  QueryDocumentSnapshot<Object> snapshot;
  _ShowUserState(this.snapshot);
  @override
  void initState() {
    if (snapshot['email'] == context.read<ChatProv>().user.email) {
      currentUser = true;
    } else {
      List userFriends = snapshot['friends'];
      if (userFriends.contains(context.read<ChatProv>().user.uid)) {
        added = true;
      } else {
        List userRequests = snapshot['friendRequests'];
        if (userRequests.contains(context.read<ChatProv>().user.uid)) {
          requested = true;
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: currentUser
            ? [
                Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.edit, size: 30)))
              ]
            : added
                ? [
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.person,
                            color: Colors.green,
                            size: 35,
                          )),
                    )
                  ]
                : [
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            requested = !requested;
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc("${snapshot.id}")
                                .update({
                              "friendRequests": requested
                                  ? FieldValue.arrayUnion(
                                      [context.read<ChatProv>().user.uid])
                                  : FieldValue.arrayRemove(
                                      [context.read<ChatProv>().user.uid])
                            });
                          });
                          SnackBar snackBar = SnackBar(
                            content: Text(
                              requested
                                  ? "Friend request sent"
                                  : "Friend request canceled",
                              style: TextStyle(fontSize: 20),
                            ),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                setState(() {
                                  requested = !requested;
                                });
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        icon: requested
                            ? const Icon(
                                Icons.person,
                                color: Colors.orange,
                                size: 35,
                              )
                            : const Icon(
                                Icons.person_add_alt_rounded,
                                size: 35,
                              ),
                      ),
                    )
                  ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.192,
                  color: Colors.black,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.23,
                    backgroundImage: snapshot['imageURL'] == ""
                        ? null
                        : NetworkImage(snapshot['imageURL'], scale: 1.0),
                    child: snapshot['imageURL'] == ""
                        ? Text(
                            "${snapshot['username'][0]}",
                            style: const TextStyle(fontSize: 50),
                          )
                        : null,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Text(
            "${snapshot['username']}",
            style: const TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

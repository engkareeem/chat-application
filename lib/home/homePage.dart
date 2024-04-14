// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../functions.dart';
import '../models/chatProvider.dart';
import '../screens/chatScreen.dart';
import '../widgets/drawerWidget.dart';
import 'package:intl/intl.dart';

import 'friends/friendRequest.dart';
import 'friends/friendsPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateFormat formatter = DateFormat('kk:mm a');
  getUser() {
    return FirebaseAuth.instance.currentUser;
  }

  initialProvider() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ChatProv>().initializeUser(getUser());
      print("=======================");
      print("Loaded");
      print("=======================");
    });
  }

  @override
  void initState() {
    initialProvider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<ChatProv>().sortChats();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Home Page"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return FriendsPage();
                }));
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return FriendRequestsPage();
                }));
              },
              child: Row(
                children: [
                  Icon(
                    Icons.group,
                    size: 30,
                    color: context.watch<ChatProv>().friendRequestsCount == 0
                        ? Colors.white
                        : Colors.orange,
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                          "${context.watch<ChatProv>().friendRequestsCount}")),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).backgroundColor,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              label: "Home",
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Calls",
              icon: Icon(Icons.call),
            ),
          ]),
      drawer: DrawerWidget(),
      body: !context.watch<ChatProv>().isReady
          ? LinearProgressIndicator()
          : Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: context.watch<ChatProv>().getFriends.length == 0
                      ? Center(
                          child: Text(
                            "You have nobody to talk him :(",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      : ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount:
                              context.watch<ChatProv>().getFriends.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, i) {
                            return Container(
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: CircleAvatar(
                                        radius:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        backgroundImage: context
                                                        .watch<ChatProv>()
                                                        .getFriends[i]
                                                    ['imageURL'] ==
                                                ""
                                            ? null
                                            : NetworkImage(
                                                context
                                                    .watch<ChatProv>()
                                                    .getFriends[i]['imageURL'],
                                                scale: 1.0),
                                        child: context
                                                        .watch<ChatProv>()
                                                        .getFriends[i]
                                                    ['imageURL'] ==
                                                ""
                                            ? Text(
                                                "${context.watch<ChatProv>().getFriends[i]['username'][0]}")
                                            : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.18,
                                    child: Text(
                                      "${context.watch<ChatProv>().getFriends[i]['username']}",
                                      // overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[400],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: context.watch<ChatProv>().chats.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ChatScreen(
                                context.watch<ChatProv>().chats[i]);
                          }));
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: ListTile(
                              leading: CircleAvatar(
                                radius:
                                    MediaQuery.of(context).size.width * 0.08,
                                backgroundImage: context
                                            .watch<ChatProv>()
                                            .chats[i]
                                            .users[1]
                                            .imageURL ==
                                        ""
                                    ? null
                                    : NetworkImage(
                                        context
                                            .watch<ChatProv>()
                                            .chats[i]
                                            .users[1]
                                            .imageURL,
                                        scale: 1.0),
                                child: context
                                            .watch<ChatProv>()
                                            .chats[i]
                                            .users[1]
                                            .imageURL ==
                                        ""
                                    ? Text(
                                        "${context.watch<ChatProv>().chats[i].users[1].username[0]}")
                                    : null,
                              ),
                              title: Text(
                                context
                                    .watch<ChatProv>()
                                    .chats[i]
                                    .users[1]
                                    .username,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: FutureBuilder(
                                        future:
                                            Functions.getUserById(context, i),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              "${snapshot.data!.username}: ${context.watch<ChatProv>().chats[i].getLastMessage.content}",
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 15,
                                              ),
                                            );
                                          } else {
                                            return Text("");
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${formatter.format(context.watch<ChatProv>().chats[i].getLastMessage.messageDate)}",
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}

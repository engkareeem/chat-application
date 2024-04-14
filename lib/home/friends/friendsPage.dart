// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chat.dart';
import '../../models/chatProvider.dart';
import '../../screens/chatScreen.dart';
import '../../widgets/drawerWidget.dart';
import '../../widgets/usersSearch.dart';
import 'friendRequest.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: const Text("Friends"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                showSearch(context: context, delegate: UsersSearchWidget());
              },
              icon: const Icon(Icons.search, size: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
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
                  ),
                  Text("${context.watch<ChatProv>().friendRequestsCount}"),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: Container(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 10),
            itemCount: context.read<ChatProv>().getFriends.length,
            itemBuilder: (context, i) {
              return Container(
                // margin: const EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.07,
                            backgroundImage: context
                                        .read<ChatProv>()
                                        .getFriends[i]['imageURL'] ==
                                    ""
                                ? null
                                : NetworkImage(
                                    context.read<ChatProv>().getFriends[i]
                                        ['imageURL'],
                                    scale: 1.0),
                            child: context.read<ChatProv>().getFriends[i]
                                        ['imageURL'] ==
                                    ""
                                ? Text(
                                    "${context.read<ChatProv>().getFriends[i]['username'][0]}",
                                    style: const TextStyle(fontSize: 25),
                                  )
                                : null,
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            child: ListTile(
                              title: Text(
                                "${context.read<ChatProv>().getFriends[i]['username']}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                "Last seen 69 minutes ago",
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  String userId =
                                      context.read<ChatProv>().getFriends[i].id;
                                  String currentUserId =
                                      context.read<ChatProv>().user.uid;
                                  Chat? chat = null;
                                  context
                                      .read<ChatProv>()
                                      .chats
                                      .forEach((chat_) {
                                    if (!chat_.isGroup) {
                                      chat_.users.forEach((user) {
                                        if (user.uid == userId) chat = chat_;
                                      });
                                    }
                                  });
                                  if (chat == null) {
                                    await context.read<ChatProv>().loadChats();
                                    context
                                        .read<ChatProv>()
                                        .chats
                                        .forEach((chat_) {
                                      if (!chat_.isGroup) {
                                        chat_.users.forEach((user) {
                                          if (user.uid == userId) chat = chat_;
                                        });
                                      }
                                    });
                                    if (chat == null) return;
                                  }
                                  Navigator.pushReplacementNamed(
                                      context, "HomePage");
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ChatScreen(chat);
                                  }));
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                                icon: isLoading
                                    ? CircularProgressIndicator()
                                    : Icon(
                                        Icons.message,
                                        color: Colors.grey[300],
                                      ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey.withOpacity(0.7),
                      indent: 15,
                      endIndent: 15,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

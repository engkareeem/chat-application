import 'package:chatapp_release/functions.dart';
import 'package:chatapp_release/models/chat.dart';
import 'package:chatapp_release/models/chatProvider.dart';
import 'package:chatapp_release/widgets/chatTextBar.dart';
import 'package:chatapp_release/widgets/messageWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final chat;
  const ChatScreen(this.chat);

  @override
  State<ChatScreen> createState() => _ChatScreenState(chat);
}

class _ChatScreenState extends State<ChatScreen> {
  Chat chat;
  TextEditingController chatTextBarController = TextEditingController();
  GlobalKey<ScaffoldState> scfKey = GlobalKey<ScaffoldState>();
  late CollectionReference messagesRef = FirebaseFirestore.instance
      .collection("chats")
      .doc(chat.chatID)
      .collection("messages");

  _ChatScreenState(this.chat);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scfKey,
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 15),
              child: CircleAvatar(
                radius: 23,
                backgroundImage: chat.users[1].imageURL == ""
                    ? null
                    : NetworkImage(chat.users[1].imageURL, scale: 1.0),
                child: chat.users[1].imageURL == ""
                    ? Text("${chat.users[1].username[0]}")
                    : null,
              ),
            ),
            Text(chat.users[1].username),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            flex: 9,
            child: StreamBuilder(
              stream: messagesRef
                  .orderBy("messageDate", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: (MediaQuery.of(context).size.height -
                            scfKey.currentState!.appBarMaxHeight!) *
                        0.9,
                    child: ListView.builder(
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      // shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, i) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: [
                              snapshot.data!.docs[i]['authorID'] ==
                                      chat.users[0].uid
                                  ? Container()
                                  : Container(
                                      margin:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundImage:
                                            chat.users[1].imageURL == ""
                                                ? null
                                                : NetworkImage(
                                                    chat.users[1].imageURL,
                                                    scale: 1.0),
                                        child: chat.users[1].imageURL == ""
                                            ? Text(
                                                "${chat.users[1].username[0]}")
                                            : null,
                                      ),
                                    ),
                              MessageWidget(
                                content: snapshot.data!.docs[i]['content'],
                                sender: snapshot.data!.docs[i]['authorID'] ==
                                    chat.users[0].uid,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text("ERROR");
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
          ChatTextBar(
            controller: chatTextBarController,
            onTap: () {
              if (chatTextBarController.text.isEmpty) return;
              context
                  .read<ChatProv>()
                  .sendMessage(chatTextBarController.text, chat);
              chatTextBarController.text = "";
            },
          ),
        ],
      ),
    );
  }
}

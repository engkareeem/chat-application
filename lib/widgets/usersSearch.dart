import 'package:chatapp_release/screens/showUserScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersSearchWidget extends SearchDelegate {
  CollectionReference usersRef = FirebaseFirestore.instance.collection("users");
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          color: Theme.of(context).primaryColor,
        ),
        textTheme: const TextTheme(
          headline6: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ));
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return showResults_(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return showResults_(context);
  }

  Widget showResults_(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: query.isEmpty
          ? null
          : StreamBuilder(
              stream: usersRef
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: query,
                    isLessThan: query.substring(0, query.length - 1) +
                        String.fromCharCode(
                            query.codeUnitAt(query.length - 1) + 1),
                  )
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                      child: Text("ERROR!",
                          style: TextStyle(fontSize: 30, color: Colors.white)));
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ShowUser(snapshot.data!.docs[i]);
                          }));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.07,
                            backgroundImage:
                                snapshot.data!.docs[i]['imageURL'] == ""
                                    ? null
                                    : NetworkImage(
                                        snapshot.data!.docs[i]['imageURL'],
                                        scale: 1.0),
                            child: snapshot.data!.docs[i]['imageURL'] == ""
                                ? Text(
                                    "${snapshot.data!.docs[i]['username'][0]}",
                                    style: const TextStyle(fontSize: 25),
                                  )
                                : null,
                          ),
                          title: Text(
                            "${snapshot.data!.docs[i]['username']}",
                            style: TextStyle(
                                fontSize: 25, color: Colors.grey[200]),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              }),
            ),
    );
  }
}

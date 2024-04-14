import 'dart:io';
import 'dart:math';

import 'package:chatapp_release/models/chatProvider.dart';
import 'package:chatapp_release/widgets/pickImageBottomSheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'menuTile.dart';
import 'package:path/path.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late bool avatarInHover = false;
  var picker = ImagePicker();

  pickImage(BuildContext context, ImageSource source) async {
    var pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      var image = File(pickedImage.path);
      var imageURL;
      if (image != null) {
        String random = Random().nextInt(100000).toString();
        var imageName = random + basename(image.path);
        var storageRef = FirebaseStorage.instance.ref("images/$imageName");
        await storageRef.putFile(image);
        imageURL = await storageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection("users")
            .doc(context.read<ChatProv>().user.uid)
            .update({"imageURL": imageURL});
        context.read<ChatProv>().refreshUser();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).backgroundColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            currentAccountPicture: GestureDetector(
              onTap: () {
                if (!avatarInHover) {
                  setState(() {
                    avatarInHover = true;
                    Future.delayed(const Duration(seconds: 3), () {
                      setState(() {
                        avatarInHover = false;
                      });
                    });
                  });
                } else {
                  showBottomSheet(context);
                }
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.08,
                backgroundImage: context.watch<ChatProv>().user.imageURL == ""
                    ? null
                    : NetworkImage(context.watch<ChatProv>().user.imageURL,
                        scale: 1.0),
                child: Stack(children: [
                  Center(
                    child: context.watch<ChatProv>().user.imageURL == ""
                        ? Text(context.read<ChatProv>().user.username[0])
                        : null,
                  ),
                  Container(
                    child: avatarInHover
                        ? const Center(
                            child: Icon(
                              Icons.edit,
                              size: 40,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  )
                ]),
              ),
            ),
            accountName: Text(
              context.watch<ChatProv>().user.username,
              style: TextStyle(fontSize: 20),
            ),
            accountEmail: Text(
              context.watch<ChatProv>().user.email,
              style: TextStyle(color: Colors.grey[300]),
            ),
          ),
          GestureDetector(
            onTap: () {
              print(ModalRoute.of(context)!.settings.name);
              if (ModalRoute.of(context)!.settings.name != "HomePage" &&
                  ModalRoute.of(context)!.settings.name != "/") {
                Navigator.pushReplacementNamed(context, "HomePage");
              }
            },
            child: const MenuTile(
              title: "Home Page",
              icon: Icons.home,
              color: Colors.white,
              size: 20.0,
            ),
          ),
          GestureDetector(
            onTap: () {
              if (ModalRoute.of(context)!.settings.name != "FriendsPage") {
                Navigator.pushReplacementNamed(context, "FriendsPage");
              }
            },
            child: const MenuTile(
              title: "Friends",
              icon: Icons.people_alt,
              color: Colors.white,
              size: 20.0,
            ),
          ),
          const MenuTile(
            title: "Chat archive",
            icon: Icons.archive,
            color: Colors.white,
            size: 20.0,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () async {
                  context.read<ChatProv>().clearProvider();
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed("LoginPage");
                },
                child: const MenuTile(
                  title: "Logout",
                  icon: Icons.logout,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        // return Container(
        //     height: MediaQuery.of(context).size.height * 0.28,
        //     child: const Center(
        //         child: Text(
        //       "Sorry, Change avatar is unavailable at current time :(",
        //       style: TextStyle(fontSize: 25),
        //     )));
        return PickImageBottomSheet(
          GallaryOnTap: () async {
            await pickImage(context, ImageSource.gallery);
            Navigator.of(context).pop();
          },
          CameraOnTap: () async {
            print("PONG");
            await pickImage(context, ImageSource.camera);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

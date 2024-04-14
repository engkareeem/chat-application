// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:chatapp_release/auth/LoginPage.dart';
import 'package:chatapp_release/auth/SignupPage.dart';
import 'package:chatapp_release/home/friends/friendsPage.dart';
import 'package:chatapp_release/models/chatProvider.dart';
import 'package:chatapp_release/screens/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'home/homePage.dart';

bool isLogin = false;
void main() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      print('connected');
    }
  } on SocketException catch (_) {
    print('not connected');
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('connected to firebase');
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    isLogin = true;
  } else {
    isLogin = false;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return ChatProv();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 150, 0, 32),
          backgroundColor: Color(0xFF1e1e1e),
          primaryTextTheme: TextTheme(
            headline1: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        home: isLogin ? HomePage() : LoginPage(),
        routes: {
          "HomePage": (context) => HomePage(),
          "LoginPage": (context) => LoginPage(),
          "SignupPage": (context) => SignupPage(),
          "FriendsPage": (context) => FriendsPage(),
        },
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/textform.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String email, password;
  GlobalKey<FormState> formState = new GlobalKey<FormState>();
  bool isLoading = false;
  login() async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      formData.save();
      setState(() {
        isLoading = true;
      });
      try {
        CollectionReference userRef =
            FirebaseFirestore.instance.collection("users");
        await userRef.doc("234243234234234234").set({
          "username": "username",
          "email": "email",
          "chats": [],
          "friendRequests": [],
          "friends": [],
          "imageURL": "",
        });
        print("no shaghal=======================");

        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AwesomeDialog(
                  context: context,
                  body: Text("No user found for that email."),
                  dialogType: DialogType.error)
              .show();
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
                  context: context,
                  body: Text("Wrong password provided for that user."),
                  dialogType: DialogType.error)
              .show();
        }
        print(e.toString() + "========================");
      }

      setState(() {
        isLoading = false;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/treeLogo.png",
                  width: 150,
                  height: 150,
                ),
                Container(
                  child: Text(
                    "Tree Project",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 50),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Form(
                    key: formState,
                    child: Column(
                      children: [
                        textForm(
                          title: "Email",
                          icon: Icons.email,
                          validator: (text) {
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(text!))
                              return "Input valid email please";
                          },
                          onSaved: (val) {
                            email = val!;
                          },
                        ),
                        SizedBox(height: 10),
                        textForm(
                          title: "Password",
                          icon: Icons.key,
                          obsecureText: true,
                          onSaved: (val) {
                            password = val!;
                          },
                          validator: (text) {
                            if (text!.length < 8)
                              return "The password must be 8 or more characters";
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        "You dont have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed("SignupPage");
                        },
                        child: Text(
                          " Click here",
                          style: TextStyle(color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      if (await login() != null) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.of(context).pushReplacementNamed("HomePage");
                      }
                    },
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            "Sign in",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

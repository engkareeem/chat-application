// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sort_child_properties_last, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import '../widgets/textform.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var username, email, password;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;
  addToUserCollection(String uid, String username, String email) async {
    CollectionReference userRef =
        FirebaseFirestore.instance.collection("users");
    await userRef.doc(uid).set({
      "username": username,
      "email": email,
      "chats": [],
      "friendRequests": [],
      "friends": [],
      "imageURL": "",
    });
  }

  Future signup() async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      formData.save();
      setState(() {
        isLoading = true;
      });
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        addToUserCollection(credential.user!.uid, username, email);
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AwesomeDialog(
                  context: context,
                  body: Text("The password provided is too weak."),
                  dialogType: DialogType.error)
              .show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
                  context: context,
                  body: Text("The account already exists for that email."),
                  dialogType: DialogType.error)
              .show();
        }
      } catch (e) {
        AwesomeDialog(
                context: context,
                body: Text("Something went wrong..."),
                dialogType: DialogType.error)
            .show();
        print("==========================================");
        print(e);
      }
      return null;
    }
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
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                  child: Form(
                    key: formState,
                    child: Column(
                      children: [
                        textForm(
                          title: "username",
                          icon: Icons.person,
                          onSaved: (val) {
                            username = val;
                          },
                          validator: (text) {
                            if (text!.length > 50)
                              return "The name must be less than 50 characters";
                            else if (text.length < 2)
                              return "The username must be 3 or more characters";
                          },
                        ),
                        SizedBox(height: 10),
                        textForm(
                          title: "Email",
                          icon: Icons.email,
                          onSaved: (val) {
                            email = val;
                          },
                          validator: (text) {
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(text!))
                              return "Input valid email please";
                          },
                        ),
                        SizedBox(height: 10),
                        textForm(
                          title: "Password",
                          icon: Icons.key,
                          obsecureText: true,
                          onSaved: (val) {
                            password = val;
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
                        "You have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushReplacementNamed("LoginPage");
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
                      if (await signup() != null) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.of(context).pushReplacementNamed("HomePage");
                      }
                    },
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            "Sign up",
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

import 'package:chatapp_release/functions.dart';
import 'package:chatapp_release/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Message {
  String messageID;
  String authorID;
  String content;
  DateTime messageDate;

  Message({
    required this.messageID,
    required this.authorID,
    required this.content,
    required this.messageDate,
  });
}

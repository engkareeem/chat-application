import 'package:chatapp_release/models/chat.dart';
import 'package:chatapp_release/models/message.dart';

class User_ {
  String uid;
  String username;
  String email;
  String imageURL;
  String getUserName() {
    return username;
  }

  User_(
      {required this.uid,
      required this.username,
      required this.email,
      required this.imageURL});
}

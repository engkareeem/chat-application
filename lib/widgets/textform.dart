// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class textForm extends StatelessWidget {
  final title;
  final icon;
  final obsecureText;
  final Function(String?) validator;
  final Function(String?) onSaved;
  const textForm(
      {required this.title,
      required this.icon,
      required this.validator,
      required this.onSaved,
      this.obsecureText});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onSaved: (val) {
        onSaved(val);
      },
      validator: (val) => validator(val),
      obscureText: (obsecureText != null) ? true : false,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}

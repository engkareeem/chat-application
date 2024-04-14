// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class PickImageBottomSheet extends StatelessWidget {
  final Function GallaryOnTap;
  final Function CameraOnTap;
  const PickImageBottomSheet(
      {required this.GallaryOnTap, required this.CameraOnTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.28,
      padding: EdgeInsets.all(20),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
          height: 5,
          width: 50,
          margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Text(
          "Please choose image source",
          style: TextStyle(
              color: Colors.grey[400],
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        InkWell(
          onTap: () => GallaryOnTap(),
          child: ListTile(
            title: Text("From Gallary",
                style: TextStyle(color: Colors.grey[400], fontSize: 23)),
            leading: Icon(Icons.photo_outlined,
                color: Theme.of(context).primaryColor),
          ),
        ),
        InkWell(
          onTap: () => CameraOnTap(),
          child: ListTile(
            title: Text("From Camera",
                style: TextStyle(color: Colors.grey[400], fontSize: 23)),
            leading: Icon(
              Icons.camera,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ]),
    );
  }
}

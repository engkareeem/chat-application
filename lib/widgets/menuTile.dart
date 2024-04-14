import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final title, icon, size, color, fontWeight;
  const MenuTile(
      {this.title, this.icon, this.size, this.color, this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title,
          style:
              TextStyle(color: color, fontSize: size, fontWeight: fontWeight)),
      leading: Icon(
        icon,
        size: size * 1.2,
        color: color,
      ),
    );
  }
}

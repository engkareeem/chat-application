import 'package:flutter/material.dart';

class ChatTextBar extends StatelessWidget {
  final Function onTap;
  final controller;
  const ChatTextBar({required this.onTap, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromARGB(86, 158, 158, 158),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.8,
            //height: MediaQuery.of(context).size.height * 0.07,
            child: TextFormField(
              maxLines: 1,
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            child: IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () => onTap(),
              icon: const FittedBox(
                child: Icon(
                  Icons.send,
                  color: Color.fromARGB(255, 150, 0, 32),
                  size: 40,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

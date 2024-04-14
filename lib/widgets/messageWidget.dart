import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final content;
  final bool sender;
  const MessageWidget({required this.content, this.sender = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: sender
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width * 0.8,
      child: Row(
        children: [
          Expanded(
            flex: sender ? 4 : 0,
            child: Container(),
          ),
          Expanded(
            flex: 6,
            child: Container(
              alignment: sender ? Alignment.centerRight : Alignment.centerLeft,
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6),
              width: 100,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: sender
                      ? const Color(0xFFbc0028)
                      : const Color(0xFF1d2a29),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: (sender)
                        ? const Radius.circular(20)
                        : const Radius.circular(0),
                    bottomRight: (sender)
                        ? const Radius.circular(0)
                        : const Radius.circular(20),
                  ),
                ),
                child: Text(
                  content,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                  softWrap: true,
                ),
              ),
            ),
          ),
          Expanded(
            flex: sender ? 0 : 4,
            child: Container(),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String name;
  final String message;

  ChatBubble({required this.name, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isMe =
        name == 'You'; // Customize this based on your user identification logic

    return Container(
      margin: isMe ? EdgeInsets.only(left: 60) : EdgeInsets.only(right: 60),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.normal,
                    color: isMe ? Colors.white : Colors.black),
              ),
              SizedBox(height: 4),
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6),
                child: Text(
                  message,
                  style: TextStyle(
                      fontSize: 16.0,
                      color: isMe ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

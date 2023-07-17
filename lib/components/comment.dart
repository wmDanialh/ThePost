import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  const Comment({
    required this.text,
    required this.user,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              // Avatar (You can add this back when you have the avatar feature ready)
              // CircleAvatar(
              //   radius: 14,
              //   backgroundImage: AssetImage('assets/user_avatar.png'),
              // ),
              // SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        user,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                          width:
                              4), // Add some spacing between the username and the blue dot
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                          width:
                              4), // Add some more spacing between the blue dot and the time
                      Text(
                        time,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

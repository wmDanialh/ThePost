import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  final String user;

  const UserList({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(10), // Changed to padding instead of 15
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(4), // Reduced border radius to 4
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

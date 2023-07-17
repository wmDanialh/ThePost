import 'package:flutter/material.dart';

class CustomAppIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/posticon.png', // Replace this with the actual path to your PNG icon
      width: 24.0, // Adjust the width as needed
      height: 24.0, // Adjust the height as needed
      color: Colors.grey, // Adjust the color as needed
    );
  }
}

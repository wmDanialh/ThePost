import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const MyTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                child: Text(
                  sectionName,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          if (onPressed != null)
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: onPressed,
                icon: Icon(Icons.edit, color: Colors.grey[600]),
              ),
            ),
        ],
      ),
    );
  }
}

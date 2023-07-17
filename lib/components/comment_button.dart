import 'package:flutter/material.dart';

class CommentButton extends StatelessWidget {
  final VoidCallback onTap;

  const CommentButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.comment,
        color: Colors.grey,
      ),
    );
  }
}

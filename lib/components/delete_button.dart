import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key, required this.onTap});
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(
        Icons.more_vert,
        color: Colors.grey,
      ),
    );
  }
}

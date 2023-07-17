import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final VoidCallback onIconPressed;

  MyAppBar({required this.onIconPressed});

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'ThePost',
        style: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 20.0,
          fontWeight: FontWeight.normal,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.navigate_next),
        onPressed: widget.onIconPressed,
      ),
    );
  }
}

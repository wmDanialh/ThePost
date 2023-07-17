import 'package:flutter/material.dart';
import 'package:thewall/components/my_list_tile.dart';

class MyDrawer extends StatelessWidget {
  final VoidCallback? onDrawerOpened;
  final void Function()? onProfileTap;
  final void Function()? onChatTap;
  final void Function()? onSignOut;

  const MyDrawer({
    Key? key,
    this.onDrawerOpened,
    this.onProfileTap,
    this.onSignOut,
    this.onChatTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //header
              const DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              // home list tile
              MyListTile(
                icon: Icons.home,
                text: 'H O M E',
                onTap: () => Navigator.pop(context),
              ),

              // profile list tile
              MyListTile(
                icon: Icons.person,
                text: 'P R O F I L E',
                onTap: onProfileTap,
              ),

              MyListTile(
                icon: Icons.message,
                text: 'M E S S A G E',
                onTap: onChatTap,
              ),
            ],
          ),
          // logout list tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              icon: Icons.logout,
              text: 'L O G O U T',
              onTap: onSignOut,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/comment.dart';
import 'package:thewall/components/user_list.dart';
import 'package:thewall/pages/chat_page.dart';

class ChatUserPage extends StatefulWidget {
  const ChatUserPage({super.key});

  @override
  State<ChatUserPage> createState() => _ChatUserPageState();
}

class _ChatUserPageState extends State<ChatUserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Your Friends',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _buildUserList(),
          ),
        ],
      ),
    );
  }

  // Build a list of users except for the current logged-in user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Users").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading..');
        }
        return Padding(
          padding: const EdgeInsets.all(10), // Add 10 padding to the ListView
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .where((userItem) => userItem != null)
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // Display all users except the current user
    if (_auth.currentUser!.email != data['email']) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiveUserEmail: data['email'],
                receiveUserID: data['uid'],
              ),
            ),
          );
        },
        child: UserList(
          user: data['email'],
        ),
      );
    } else {
      return Container();
    }
  }
}

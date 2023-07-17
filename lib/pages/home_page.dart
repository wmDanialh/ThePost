import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/custom_app_icon.dart';
import 'package:thewall/components/drawer.dart';
import 'package:thewall/components/my_appbar.dart';
import 'package:thewall/components/text_field.dart';
import 'package:thewall/components/wall_post.dart';
import 'package:thewall/helper/helper_methods.dart';
import 'package:thewall/pages/chat_user_page.dart';
import 'package:thewall/pages/profile_page.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User? currentUser;
  final textController = TextEditingController();

  void _handleScreenTap(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void signOut() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () async {
              // Perform the sign-out
              await FirebaseAuth.instance.signOut();

              // Pop the screen to go back after successful logout
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void postMessage() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail': currentUser!.email!,
        'Message': textController.text,
        'Timestamp': Timestamp.now(),
        'Likes': [],
      });
      textController.clear();
    }
  }

  void goToProfilePage() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  void goToChatPage() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatUserPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomAppIcon(), // Use your custom icon here
            SizedBox(width: 8.0), // Add spacing between icon and title
          ],
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(
        onChatTap: goToChatPage,
        onProfileTap: goToProfilePage,
        onSignOut: signOut,
      ),
      body: GestureDetector(
        onTap: () => _handleScreenTap(context),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy("Timestamp",
                        descending:
                            true) // Set descending to true for latest posts first
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return WallPost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          time: formatDate(post['Timestamp']),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: 'Write something on ThePost...',
                      obscureText: false,
                    ),
                  ),
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(Icons.arrow_circle_up),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Text(
                "Logged in as: ${currentUser?.email ?? 'Guest'}",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

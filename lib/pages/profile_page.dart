import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/components/text_box.dart';
import 'package:thewall/components/wall_post.dart';
import 'package:flutter/services.dart';
import 'package:thewall/helper/helper_methods.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!;
  // all users
  final userCollection = FirebaseFirestore.instance.collection("Users");

  Future<void> editField(BuildContext context, String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter new $field',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // Cancel button
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          // Save button
          TextButton(
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context, newValue),
          ),
        ],
      ),
    );

    // Update in Firestore
    if (newValue.trim().length > 0) {
      // Only update if there is something in the text field
      await userCollection.doc(currentUser.uid).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Profile Page',
          style: TextStyle(
            fontFamily: "Montserrat", // Use the custom font family
            fontSize: 20.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: true, // Align the title at the center
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(currentUser.uid) // Use currentUser.uid as the document ID
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Get user data
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            final userEmail = currentUser.email; // Get the user's email

            return ListView(
              children: [
                // Profile Picture
                // You can use a Container or an Image widget to display the profile picture here
                const SizedBox(height: 50),
                Icon(
                  Icons.person,
                  size: 72,
                ),
                const SizedBox(height: 10),

                // User Email
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 50),

                // User Details
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Details',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                // Username
                MyTextBox(
                  text: userData['username'],
                  sectionName: 'Username',
                  onPressed: () => editField(context, 'username'),
                ),

                // Bio
                MyTextBox(
                  text: userData['bio'],
                  sectionName: 'Bio',
                  onPressed: () => editField(context, 'bio'),
                ),
                const SizedBox(height: 10),

                // User Posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'My Posts',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                // User Posts List
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("User Posts")
                      .where('UserEmail',
                          isEqualTo:
                              userEmail) // Filter posts by the user's email
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final userPosts = snapshot.data!.docs;

                      if (userPosts.isEmpty) {
                        return Center(
                          child: Text('No posts to display.'),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: userPosts.length,
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

                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

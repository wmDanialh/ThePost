import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:thewall/components/comment.dart';
import 'package:thewall/components/comment_button.dart';
import 'package:thewall/components/delete_button.dart';
import 'package:thewall/components/like_button.dart';
import 'package:thewall/helper/helper_methods.dart';

class WallPost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;

  const WallPost({
    Key? key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
  }) : super(key: key);

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  late User currentUser;
  bool isLiked = false;

  //comment context controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

    if (isLiked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("User Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now()
    });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: InputDecoration(hintText: "Write a comment.."),
        ),
        actions: [
          //save button
          TextButton(
            onPressed: () {
              // add comment
              addComment(_commentTextController.text);

              //popbox
              Navigator.pop(context);

              _commentTextController.clear();
            },
            child: Text("Post"),
          ),

          //cancel button
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              //clear controller
              _commentTextController.clear();
            },
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void deletePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text(
            "Are you sure you want to delete this post and its comments?"),
        actions: [
          TextButton(
            onPressed: () async {
              // Delete the comments from Firestore first
              final commentDocs = await FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection('Comments')
                  .get();

              for (var doc in commentDocs.docs) {
                await FirebaseFirestore.instance
                    .collection("User Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .doc(doc.id)
                    .delete();
              }

              // Then delete the post
              FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .delete()
                  .then((value) {
                print("Post deleted");
                Navigator.pop(
                    context); // Close the AlertDialog after successful deletion
              }).catchError((error) {
                print("Error deleting post: $error");
                Navigator.pop(
                    context); // Close the AlertDialog on error as well
              });
            },
            child: const Text("Delete"),
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
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.message,
                      // ... Your message style ...
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.user,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 4),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 4),
                            Text(
                              widget.time,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        // Likes and Comment buttons here
                        // ...
                      ],
                    ),
                  ],
                ),
                //delete button
                if (widget.user == currentUser.email)
                  DeleteButton(
                    onTap: deletePost,
                  ),
              ],
            ),

            SizedBox(height: 8.0),

            Row(
              children: [
                Column(
                  children: [
                    LikeButton(
                      isLiked: isLiked,
                      onTap: toggleLike,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.likes.length.toString(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(width: 5),
                Column(
                  children: [
                    CommentButton(onTap: showCommentDialog),
                    const SizedBox(height: 5),
                    Text(
                      '0',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 8.0),

            // comments under the post
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("User Posts")
                  .doc(widget.postId)
                  .collection("Comments")
                  .orderBy("CommentTime", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    final commentData = doc.data() as Map<String, dynamic>;
                    return Comment(
                      text: commentData["CommentText"],
                      user: commentData["CommentedBy"],
                      time: formatDate(commentData["CommentTime"]),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thewall/model/message.dart';

class ChatService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //send message
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );

    // construct chat room id from current user id and receiver id (sorted)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the ids (this ensures the chat room id is alwasys the samme for any pair of)
    String chatRoomId = ids.join(
        "_"); // combine the ids into a single string to use a a chatroomID

    //add new message to database
    await _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // GET MESSAGES
  Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
    //construct chat room id from user ids (sorted to enrure it matches the id used when sending messages)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomdId = ids.join("_");

    return _fireStore
        .collection('chat_rooms')
        .doc(chatRoomdId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}

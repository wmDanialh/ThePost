import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  //convert to a map
  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'senderEmail': senderEmail,
      'receiver_id': receiverId,
      'messages': message,
      'timestamp': timestamp,
    };
  }
}

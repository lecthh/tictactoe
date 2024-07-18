import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String sender;
  final String senderEmail;
  final String receiver;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.sender,
    required this.senderEmail,
    required this.receiver,
    required this.message,
    required this.timestamp
  });

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'senderEmail': senderEmail,
      'receiver': receiver,
      'message': message,
      'timestamp': timestamp
    };
  }
}
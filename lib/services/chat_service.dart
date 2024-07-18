import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_proj/services/auth_service.dart';
import 'package:final_proj/utils/message.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  final authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send message
  Future<void> sendMessage(String roomId, String message) async {
    final String currentUser = (await authService.getUsername())!;
    final String currentUserEmail = authService.getEmail()!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
      sender: currentUser,
      senderEmail: currentUserEmail,
      receiver: '', 
      message: message,
      timestamp: timestamp,
    );

    // Add new message
    await _firestore
        .collection('gameRooms')
        .doc(roomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //get msgs
  Stream<QuerySnapshot> getMessages(String roomId, String currentUser, String otherUser) {
    return _firestore
      .collection('gameRooms')
      .doc(roomId)
      .collection('messages')
      .orderBy('timestamp', descending: false)
      .snapshots();
  }
}

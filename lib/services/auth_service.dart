import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //sign up
  Future<User?> signUp(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      User? user = result.user;

      //usernamt to firestore
      await _firestore.collection('users').doc(user?.uid).set({
        'username': username,
        'email': email
      });

      return user;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  //sign in
  Future<User?> signIn(String username, String password) async {
    try {
      QuerySnapshot result = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

        if (result.docs.isEmpty) return null;

        String email = result.docs.first['email'];

        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
        );

        return userCredential.user;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }

  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //get username of logged in user
  Future<String?> getUsername() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      return userDoc['username'];
    }
    return null;
  }

  //get email
  String? getEmail(){
    User? user = _auth.currentUser;
    return user?.email;
  }
  
  //sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../modals/photo_modal.dart';
import '../utils/api_key.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  get user => _auth.currentUser;
  bool isLoading = false;

  //sign up user
  Future signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //sign in user
  Future signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //sign out
  Future signOut() async {
    await _auth.signOut();
  }
}

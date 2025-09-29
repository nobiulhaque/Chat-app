import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getcurentUser() {
    return _auth.currentUser;
  }

  // 🔹 Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 🔹 Current logged-in user
  User? get currentUser => _auth.currentUser;

  // 🔹 Sign In
  Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // 🔹 Sign Up (with name, email, password)
  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user info in a separate doc
      await _firestore.collection("Users").doc(userCred.user!.uid).set({
        'uid': userCred.user!.uid,
        'email': email.trim(),
        'name': name.trim(),
        'createdAt':
            FieldValue.serverTimestamp(),
      });

      await userCred.user?.updateDisplayName(name);

      return userCred;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  // 🔹 Sign Out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // 🔹 Error handling
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'That email is already registered.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'weak-password':
        return 'Password is too weak.';
      default:
        return 'Please Log In Properly.';
    }
  }
}

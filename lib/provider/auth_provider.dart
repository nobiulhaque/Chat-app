import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    // Listen to Firebase's auth state changes and update the local state
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      // 🎯 NOTIFY: This instantly tells all listening widgets (AuthGate) to rebuild.
      notifyListeners(); 
    });
  }

  User? get user => _user;

  Future<void> signOut() async {
    await _auth.signOut();
    // No need to call notifyListeners here; the stream listener above handles it.
  }
}
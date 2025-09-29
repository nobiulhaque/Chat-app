// global_chat_notifier.dart - FINAL REVISED IMPLEMENTATION

import 'package:chat_app/services/notification/notifi_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GlobalChatNotifier {
  void startListening() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    auth.authStateChanges().listen((user) {
      if (user == null) return;

      final String currentUserID = user.uid;

      firestore
          .collectionGroup("messages")
          .where("receiverID", isEqualTo: currentUserID)
          .orderBy("timestamp", descending: true)
          .limit(10)
          .snapshots()
          .listen((messagesSnapshot) async {
            for (var change in messagesSnapshot.docChanges) {
              if (change.type == DocumentChangeType.added) {
                final data = change.doc.data() as Map<String, dynamic>;
                
                if (data["senderID"] != currentUserID) { 
                  
                  final String senderID = data["senderID"];
                  
                  // Fetch the sender's details from the 'Users' collection
                  DocumentSnapshot userDoc = 
                      await firestore.collection('Users').doc(senderID).get();
                  
                  String senderName = "User"; // Default fallback

                  if (userDoc.exists) {
                    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
                    
                    // 🎯 FINAL FIX: Use the 'name' field as identified from your database
                    if (userData.containsKey('name') && userData['name'] != null) {
                        senderName = userData['name']!;
                    } 
                    // Fallback to email if 'name' is somehow empty
                    else if (userData.containsKey('email') && userData['email'] != null) {
                        senderName = userData['email']!;
                    }
                  } 
                  
                  // Final fallback
                  else if (data.containsKey("senderEmail") && data["senderEmail"] != null) {
                      senderName = data["senderEmail"];
                  }

                  NotifiService().showNotification(
                    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                    title: "New message from $senderName",
                    body: data["message"],
                  );
                }
              }
            }
          });
    });
  }
}
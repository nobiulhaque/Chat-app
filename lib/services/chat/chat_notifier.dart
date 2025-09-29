import 'package:chat_app/services/chat/chat_services.dart';
import 'package:chat_app/services/notification/notifi_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void listenForMessages(String otherUserID) {
    final String currentUserID = _auth.currentUser!.uid;

    ChatService()
        .getMessages(currentUserID, otherUserID)
        .listen((QuerySnapshot snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data() as Map<String, dynamic>;

          if (data["senderID"] != currentUserID) {
            NotifiService().showNotification(
              id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
              title: "New message",
              body: data["message"],
            );
          }
        }
      }
    });
  }
}

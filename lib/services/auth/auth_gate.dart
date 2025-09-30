
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/provider/provider.dart';
import 'package:chat_app/services/chat/global_chat_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  GlobalChatNotifier? _chatNotifier;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = Provider.of<ChatProvider>(context);

    if (auth.user != null && _chatNotifier == null) {
      // Only start listening once when the user is logged in
      _chatNotifier = GlobalChatNotifier()..startListening();
    }
  }

  @override
  void dispose() {
    // Optional: if your notifier has a stopListening() method, call it here
    // _chatNotifier?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ChatProvider>(
        builder: (context, auth, child) {
          if (auth.user != null) {
            return HomePage();
          }
          return LoginPage();
        },
      ),
    );
  }
}

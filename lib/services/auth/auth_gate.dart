
import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/provider/auth_provider.dart';
import 'package:chat_app/services/chat/global_chat_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎯 Consume the state from the AuthProvider
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.user != null) {
            // User is logged in
            GlobalChatNotifier().startListening(); 
            return HomePage();
          }
          // User is NOT logged in (instant redirection on signOut)
          return LoginPage();
        },
      ),
    );
  }
}
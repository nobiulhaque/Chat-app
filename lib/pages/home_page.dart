// lib/pages/home_page.dart

import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/provider/provider.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Required for Provider/AuthProvider
import 'package:chat_app/services/auth/auth_gate.dart'; // Required for final pushAndRemoveUntil

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Chat and Auth Service instances
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService(); // Used to get current user details

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Home",
          style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // 1. Call Provider's signOut
              await Provider.of<ChatProvider>(context, listen: false).signOut();
              
              // 2. 🎯 FIX: Clear the navigation stack entirely and push AuthGate.
              // This guarantees immediate visual redirection to the LoginPage.
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const AuthGate(),
                ),
                (Route<dynamic> route) => false, // Remove all previous routes
              );
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ],
      ),
      body: _buildUserlist(),
    );
  }

  // Build a list of users except for the current logged-in user
  Widget _buildUserlist() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // Error handling
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading users"));
        }

        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Data check
        if (snapshot.data == null || snapshot.data!.isEmpty) {
             return const Center(child: Text("No users found."));
        }

        // Return ListView
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserlistItem(userData, context))
              .toList(),
        );
      },
    );
  }

  // Build individual List tile for user
  Widget _buildUserlistItem(
    Map<String, dynamic> userData,
    BuildContext context,
  ) {
    // 🎯 FIX: Safely retrieve the current user's email using the null-aware operator (?.)
    // This prevents the Null check operator crash when logging out.
    final currentUserEmail = _authService.getcurentUser()?.email;

    // 1. If the current user's email is null (meaning logged out/logging out), 
    //    return an empty container to prevent the crash.
    if (currentUserEmail == null) {
      return Container(); 
    }

    // 2. Display all users EXCEPT the current user
    if (userData["email"] != currentUserEmail) {
      // Safely read name and email (though they should exist based on your user service)
      final String receiverName = userData["name"] ?? userData["email"] ?? "User";
      final String receiverEmail = userData["email"] ?? "N/A";
      final String receiverID = userData["uid"] ?? "N/A";

      return UserTile(
        name: receiverName,
        email: receiverEmail,
        onTap: () {
          // Tapped on a user -> go to the chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receivername: receiverName, 
                receiveID: receiverID,
              ),
            ),
          );
        },
      );
    } else {
      // This is the current user, so return an empty container
      return Container();
    }
  }
}
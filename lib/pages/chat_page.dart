import 'package:chat_app/components/textfield.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receivername;
  final String receiveID;

  const ChatPage({
    super.key,
    required this.receivername,
    required this.receiveID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiveID, _messageController.text);

      _messageController.clear();

      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receivername)),
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 15),
        child: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildUserInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getcurentUser()!.uid;
    // Note: The message order fix was in ChatService (descending: true).
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiveID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading messages"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading..."));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No messages yet..."));
        }

        return ListView(
          // 🎯 ATTACH: Attach the scroll controller
          controller: _scrollController,
          // RETAIN: Keeps the list starting from the bottom
          reverse: true,
          children: snapshot.data!.docs
              .map((doc) => _buildMessageListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String senderID = _authService.getcurentUser()!.uid;
    bool isMe = data["senderID"] == senderID;

    // Determine the colors based on whether the message is outgoing (isMe) or incoming.
    final Color bubbleColor = isMe
        ? Theme.of(context)
              .colorScheme
              .inversePrimary // Your message bubble color
        : Theme.of(context).colorScheme.tertiary; // Their message bubble color

    // 🎯 NEW: Determine the text color to contrast with the bubble color.
    final Color textColor = isMe
        ? Theme.of(context)
              .colorScheme
              .tertiary // e.g., White or light color for inversePrimary background
        : Theme.of(context)
              .colorScheme
              .inversePrimary; // e.g., Black or dark color for tertiary background

    return Container(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(12),
        ),
        // 🎯 APPLY the new textColor here
        child: Text(
          data["message"],
          style: TextStyle(
            fontSize: 16,
            color: textColor, // Apply the chosen color
          ),
        ),
      ),
    );
  }

  Widget _buildUserInput() {
    return SafeArea(
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: MyTextfield(
                hintText: 'Type a message',
                obscureText: false,
                controller: _messageController,
              ),
            ),
          ),
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(Icons.arrow_upward),
          ),
        ],
      ),
    );
  }
}

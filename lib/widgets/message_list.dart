import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import 'chat_bubble.dart';

class MessageList extends StatelessWidget {
  final List<ChatMessage> messages;

  const MessageList({
    super.key,
    required this.messages,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ChatBubble(
          message: messages[index],
        );
      },
    );
  }
}
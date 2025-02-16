import 'package:flutter/material.dart';

import '../../theme/themeData.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser ? MyTheme.accentColor : Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Text(
            message.substring(5),
            style: TextStyle(
              color: isUser ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat('hh:mm a').format(message.time);

    return Row(
      mainAxisAlignment: message.isUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!message.isUser)
          const CircleAvatar(child: Icon(Icons.smart_toy)),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.65,
              ),
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue : Colors.grey[700],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.text,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Text(formatted, style: const TextStyle(fontSize: 10)),
          ],
        ),
        const SizedBox(width: 6),
        if (message.isUser)
          const CircleAvatar(child: Icon(Icons.person)),
      ],
    );
  }
}
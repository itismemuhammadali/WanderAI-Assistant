import 'package:flutter/material.dart';
import '../core/theme.dart';

class ChatBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final Widget? embeddedWidget;

  const ChatBubble({
    Key? key,
    required this.message,
    this.embeddedWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isMe = message['isMe'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isMe ? AppTheme.accentTeal : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 0),
                bottomRight: Radius.circular(isMe ? 0 : 20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message['text'],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isMe ? Colors.white : AppTheme.textPrimary,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8, right: 8),
            child: Text(
              message['time'],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
            ),
          ),
          if (embeddedWidget != null && !isMe) ...[
            const SizedBox(height: 8),
            embeddedWidget!,
          ]
        ],
      ),
    );
  }
}

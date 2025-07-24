import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final DateTime? time;

  const MessageBubble({
    required this.text,
    required this.sender,
    required this.isMe,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = time != null ? DateFormat.Hm().format(time!) : '';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender, style: TextStyle(fontSize: 12, color: Colors.grey)),
          Material(
            borderRadius: BorderRadius.circular(12),
            color: isMe ? Colors.blue[200] : Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  if (text.isNotEmpty) Text(text),
                  if (formattedTime.isNotEmpty)
                    Text(formattedTime,
                        style: TextStyle(fontSize: 10, color: Colors.black54)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

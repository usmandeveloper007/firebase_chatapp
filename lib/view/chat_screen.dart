import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_chat_app/controllers/auth_controllers.dart';
import 'package:firebase_chat_app/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  final chatController = Get.put(ChatController());
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final email = user?.email ?? "Anonymous";

    return Scaffold(
      appBar: AppBar(
        title: Text("Chat - $email"),
        actions: [
          IconButton(
              onPressed: () => Get.find<AuthController>().logout(),
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: chatController.chatStream(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Something went wrong!'));
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return Center(child: Text('No messages yet'));
                  }

                  final docs = snapshot.data!.docs;
                  chatController.scrollToBottom();

                  return ListView.builder(
                    controller: chatController.scrollController,
                    itemCount: docs.length,
                    itemBuilder: (ctx, i) {
                      final data = docs[i];
                      final dataMap = data.data() as Map<String, dynamic>;
                      final isMe = dataMap['sender'] == email;

                      return MessageBubble(
                        text: dataMap['text'] ?? '',
                        isMe: isMe,
                        time: (dataMap['timestamp'] as Timestamp?)?.toDate(),
                        sender: dataMap['sender'] ?? '',
                      );
                    },
                  );
                }),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController.messageController,
                    decoration: InputDecoration(hintText: "Type a message..."),
                    onChanged: (value) =>
                        chatController.messageText.value = value,
                    onSubmitted: (_) => chatController.sendMessage(
                        chatController.messageController.text, email),
                  ),
                ),
                Obx(() => IconButton(
                      onPressed: chatController.messageText.value.trim().isEmpty
                          ? null
                          : () => chatController.sendMessage(
                              chatController.messageController.text, email),
                      icon: Icon(Icons.send),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}

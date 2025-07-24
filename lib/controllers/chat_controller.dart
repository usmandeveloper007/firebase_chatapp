import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  RxString messageText = ''.obs;

  Stream<QuerySnapshot> chatStream() {
    return FirebaseFirestore.instance
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  Future<void> sendMessage(String text, String email) async {
    if (text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('messages').add({
      'text': text,
      'sender': email,
      'timestamp': FieldValue.serverTimestamp(),
    });

    messageController.clear();
    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

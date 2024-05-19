import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewMessages extends StatefulWidget {
  const NewMessages({super.key});

  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final msgController = TextEditingController();
  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  void submitMessage() async {
    final enteredMsg = msgController.text;
    if (enteredMsg.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    msgController.clear();
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMsg,
      'created_at': Timestamp.now(),
      'user_id': user.uid,
      'user_name': userData.data()!['user_name'],
      'user_image': userData.data()!['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: msgController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
              color: Theme.of(context).colorScheme.primary,
              onPressed: submitMessage,
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}

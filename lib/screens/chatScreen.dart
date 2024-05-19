import 'package:demo/widgets/chat_messages.dart';
import 'package:demo/widgets/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(
                  Icons.exit_to_app_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ))
          ],
          title: Text('Chat Screen'),
        ),
        body: Column(
          children: const [Expanded(child: ChatMessages()), NewMessages()],
        ));
  }
}

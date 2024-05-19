import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No message found'),
            );
          }
          if (chatSnapshots.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          final loadedMsg = chatSnapshots.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
            reverse: true,
            itemCount: loadedMsg.length,
            itemBuilder: (ctx, index) {
              final chatMsg = loadedMsg[index].data();
              final nextChatMsg = index + 1 < loadedMsg.length
                  ? loadedMsg[index + 1].data()
                  : null;

              final currMsgUserId = chatMsg['user_id'];
              final nextMsgUserId =
                  nextChatMsg != null ? nextChatMsg['user_id'] : null;
              final nextUserIsSame = nextMsgUserId == currMsgUserId;

              if (nextUserIsSame) {
                return MessageBubble.next(
                    message: chatMsg['text'],
                    isMe: authUser.uid == currMsgUserId);
              } else {
                return MessageBubble.first(
                    userImage: chatMsg['user_image'],
                    username: chatMsg['user_name'],
                    message: chatMsg['text'],
                    isMe: authUser.uid == currMsgUserId);
              }
            },
          );
        });
  }
}

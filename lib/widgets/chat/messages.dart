import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          var chatDocs = (chatSnapshot
                  as AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>)
              .data!
              .docs;
          return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, idx) => MessageBubble(
              chatDocs[idx]['text'],
              chatDocs[idx]['username'],
              chatDocs[idx]['userImage'],
              chatDocs[idx]['userId'] == FirebaseAuth.instance.currentUser!.uid,
              key: ValueKey(chatDocs[idx].id),
            ),
          );
        });
  }
}

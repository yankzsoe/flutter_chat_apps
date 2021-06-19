import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats/qbF6BToXEPKl05PqOcE5/messages')
              .snapshots(),
          builder: (ctx, streamSnapshot) {
            return (streamSnapshot.connectionState == ConnectionState.waiting)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: (streamSnapshot as AsyncSnapshot<
                            QuerySnapshot<Map<String, dynamic>>>)
                        .data!
                        .docs
                        .length,
                    itemBuilder: (ctx, index) => Container(
                      padding: EdgeInsets.all(8),
                      child: Text(streamSnapshot.data!.docs[index]['text']),
                    ),
                  );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

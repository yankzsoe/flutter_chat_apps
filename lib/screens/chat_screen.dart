import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Apps'),
        actions: [
          DropdownButton(
            dropdownColor: Theme.of(context).accentColor,
            items: [
              DropdownMenuItem<String>(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            onChanged: (value) {
              if (value == 'logout') FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
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
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/qbF6BToXEPKl05PqOcE5/messages')
              .add({'text': 'this value add by clicking'});
        },
      ),
    );
  }
}

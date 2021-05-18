import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class post_users extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final titleTextStyle = Theme.of(context).textTheme.title;
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('books').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return ListView(
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return ListTile(
              title: Text(document['title']),
            );
          }).toList(),
        );
      },
    );
  }
} // ナビゲーションバーをタップした時に切り替わるWidgetの定義

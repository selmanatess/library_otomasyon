import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widget/bookCard.dart';

class bookScreen extends StatelessWidget {
  const bookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("books").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  return BookCard(
                    uid: snapshot.data!.docs[index]["uid"],
                  );
                },
              );
            } else
              return Center(
                child: CircularProgressIndicator(color: Colors.pinkAccent),
              );
          },
        ));
  }
}

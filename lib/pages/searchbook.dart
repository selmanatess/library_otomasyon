import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_otomation/widget/bookCard.dart';

class SearchBook extends StatefulWidget {
  final List<bool> isSelectedList;
  final int minpage;
  final int maxpage;

  const SearchBook(
      {super.key,
      required this.isSelectedList,
      required this.minpage,
      required this.maxpage});

  @override
  State<SearchBook> createState() => _SearchBookState();
}

class _SearchBookState extends State<SearchBook> {
  List<String> options = [
    'Roman',
    'Klasik Edebiyat',
    'Polisiye',
    'Bilim Kurgu',
    'Fantastik',
    'Siyasi',
    'Dini',
    'Macera',
    'Korku',
    'Teknoloji'
  ];

  List selectedCategory = [];

  @override
  void initState() {
    for (var i = 0; i < widget.isSelectedList.length; i++) {
      if (widget.isSelectedList[i] == true) {
        selectedCategory.add(options[i]);
      }
    }
    for (var element in selectedCategory) {
      print(element);
    }
    print(widget.maxpage);
    print(widget.minpage);
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arama Sonuçları"),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('books')
            .where('category', whereIn: selectedCategory)
            .where('pagecount', isGreaterThanOrEqualTo: widget.minpage)
            .where('pagecount', isLessThanOrEqualTo: widget.maxpage)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Veri yok'));
          }

          List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
          print("liste boyutu" + docs.length.toString());
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> bookData =
                  (docs[index].data() as Map<String, dynamic>);

              String uid = bookData["uid"];
              print(uid);
              return BookCard(uid: uid);
            },
          );
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../constant/utils.dart';
import '../widget/bookCard.dart';
import '../widget/normal_button.dart';
import 'homepage.dart';

class BorrowScreen extends StatefulWidget {
  const BorrowScreen({super.key});

  @override
  State<BorrowScreen> createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  String authuid = auth.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text("Ödünç Aldığım Kitaplar"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(authuid)
            .collection("borrow")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                return borrowcard(snapshot.data!.docs[index]["uid"]);
              },
            );
          } else
            return Center(
              child: CircularProgressIndicator(color: Colors.pinkAccent),
            );
        },
      ),
    );
  }

  Widget borrowcard(String uid) {
    return StreamBuilder(
      stream: firestore
          .collection("users")
          .doc(auth.currentUser!.uid)
          .collection("borrow")
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 65.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: 40.h,
                  width: 75.w,
                  child: Image(image: NetworkImage(snapshot.data!["imageUrl"])),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      snapshot.data!["bookname"],
                      style: TextStyle(fontSize: 22),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: "Türü ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                            TextSpan(
                                text: snapshot.data!["category"],
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ])),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: "Yazarı ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                            TextSpan(
                                text: snapshot.data!["writer"],
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ]))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: "Sayfa sayısı ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                            TextSpan(
                                text: "${snapshot.data!["pagecount"]}",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ])),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: "Yayınevi ",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                            TextSpan(
                                text: snapshot.data!["publisher"],
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ]))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          normalButton(
                              child: Text("İade Et"),
                              color: Colors.pinkAccent.shade400,
                              isLoading: false,
                              onPressed: () async {
                                await firestore
                                    .collection("books")
                                    .doc(snapshot.data!["uid"])
                                    .set({
                                  "bookname": snapshot.data!["bookname"],
                                  "category": snapshot.data!["category"],
                                  "imageUrl": snapshot.data!["imageUrl"],
                                  "pagecount": "${snapshot.data!["pagecount"]}",
                                  "publisher": snapshot.data!["publisher"],
                                  "uid": snapshot.data!["uid"],
                                  "writer": snapshot.data!["writer"]
                                });
                                utils()
                                    .showSnackBar(context, "Kitap iade edildi");
                                await firestore
                                    .collection("users")
                                    .doc(authuid)
                                    .collection("borrow")
                                    .doc(snapshot.data!["uid"])
                                    .delete();
                              },
                              width: 50.w,
                              height: 5.h),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]),
          );
        } else
          return Center(
            child: Text("Bir şeyler yanlış gitti"),
          );
      },
    );
  }
}

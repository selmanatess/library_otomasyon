import 'package:flutter/material.dart';
import 'package:library_otomation/pages/homepage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../widget/normal_button.dart';

class Book extends StatelessWidget {
  final String uid;
  const Book({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore.collection("books").doc(uid).snapshots(),
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
                      child: normalButton(
                          child: Text("Ödünç Al"),
                          color: Colors.pinkAccent.shade400,
                          isLoading: false,
                          onPressed: () {},
                          width: 50.w,
                          height: 5.h),
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

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_otomation/constant/utils.dart';
import 'package:library_otomation/pages/homepage.dart';
import 'package:library_otomation/widget/bookadd.dart';

import 'package:library_otomation/widget/textediting.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uuid/uuid.dart';

import '../widget/normal_button.dart';

class AddbookScreen extends StatefulWidget {
  const AddbookScreen({super.key});

  @override
  State<AddbookScreen> createState() => _AddbookScreenState();
}

class _AddbookScreenState extends State<AddbookScreen> {
  bool isbookadd = false;
  bool isdelete = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Visibility(
            visible: !isbookadd,
            child: normalButton(
                child: Text("Kitap Ekle"),
                color: Colors.pinkAccent.shade400,
                isLoading: false,
                onPressed: () {
                  setState(() {
                    isbookadd = !isbookadd;
                    isdelete = false;
                  });
                },
                width: 90.w,
                height: 10.h),
          ),
          Visibility(visible: isbookadd, child: bookadd()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Visibility(
              visible: !isdelete,
              child: normalButton(
                  child: Text("Kitap Sil"),
                  color: Colors.pinkAccent.shade400,
                  isLoading: false,
                  onPressed: () {
                    setState(() {
                      isdelete = !isdelete;
                      isbookadd = false;
                    });
                  },
                  width: 90.w,
                  height: 10.h),
            ),
          ),
          Visibility(
            visible: isdelete,
            child: Container(
              height: 60.h,
              width: 95.w,
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("books").snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image(
                              image: NetworkImage(
                                  snapshot.data!.docs[index]["imageUrl"])),
                          title: Text(snapshot.data!.docs[index]["bookname"]),
                          subtitle: Text(snapshot.data!.docs[index]["writer"]),
                          trailing: IconButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Uyarı!"),
                                      content: Text(
                                          "Kitabı silmek istediğinize emin misiniz?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () async {
                                              await firestore
                                                  .collection("books")
                                                  .doc(snapshot
                                                      .data!.docs[index]["uid"])
                                                  .delete();
                                              FirebaseStorage storage =
                                                  FirebaseStorage.instance;
                                              String imageURL = snapshot.data!
                                                  .docs[index]["imageUrl"];
                                              Reference ref =
                                                  storage.refFromURL(imageURL);

                                              ref.delete().then((_) {
                                                // Resim başarıyla silindi
                                              }).catchError((error) {
                                                // Hata oluştu, resim silinemedi
                                              });

                                              Navigator.pop(context);
                                            },
                                            child: Text("Evet")),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("Hayır"))
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                color: Colors.red,
                                Icons.delete,
                                size: 40,
                              )),
                        );
                      },
                    );
                  } else
                    return CircularProgressIndicator();
                },
              ),
            ),
          )
        ],
      )),
    );
  }
}

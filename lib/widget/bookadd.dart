import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uuid/uuid.dart';

import '../constant/utils.dart';
import '../pages/homepage.dart';
import 'normal_button.dart';

class bookadd extends StatefulWidget {
  const bookadd({super.key});

  @override
  State<bookadd> createState() => _bookaddState();
}

TextEditingController booknameController = TextEditingController();
TextEditingController PagecountController = TextEditingController();
TextEditingController writerController = TextEditingController();
TextEditingController yayinameController = TextEditingController();

class _bookaddState extends State<bookadd> {
  late FocusNode focusNode;
  String? selectedOption;
  bool isloading = false;
  List<String> options = [
    'Roman',
    'Klasik Edebiyat',
    'Polisiye',
    'Bilim Kurgu',
    'Fantastik',
    'siyasi',
    'Dini',
    'Macera',
    'Korku',
    'Teknoloji'
  ];
  bool isInFocus = false;
  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          isInFocus = false;
        });
      } else {
        setState(() {
          isInFocus = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: InkWell(
              onTap: () {
                showbottom();
              },
              child: GetBuilder<imageController>(
                init: imageController(),
                builder: (controller) {
                  return Container(
                    height: 40.h,
                    width: 75.w,
                    child: controller.image != null
                        ? Image(image: NetworkImage(controller.image!))
                        : Center(
                            child: Text(
                                "Kitabın Kapak Fotoğrafını buraya yükleyin")),
                  );
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Kitabın Adı   ",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Container(
                      height: 5.h,
                      width: 55.w,
                      child: TextField(
                        controller: booknameController,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.blueGrey)),
                            focusColor: Colors.pinkAccent,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.pinkAccent)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.pinkAccent.shade700),
                                borderRadius: BorderRadius.circular(8))),
                      ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Kategori  ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                    DropdownButton<String>(
                      underline: Container(
                        height: 2,
                        color: Colors.pinkAccent.shade700,
                      ),
                      dropdownColor: Colors.pink.shade50,
                      value: selectedOption,
                      hint:
                          Text('Lütfen bir seçenek seçin'), // Varsayılan metin
                      items: options.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Yazarı  ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                    Container(
                        height: 5.h,
                        width: 55.w,
                        child: TextField(
                          controller: writerController,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.blueGrey)),
                              focusColor: Colors.pinkAccent,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.pinkAccent)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.pinkAccent.shade700),
                                  borderRadius: BorderRadius.circular(8))),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Yayın Evi  ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                    Container(
                        height: 5.h,
                        width: 55.w,
                        child: TextField(
                          controller: yayinameController,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.blueGrey)),
                              focusColor: Colors.pinkAccent,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.pinkAccent)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.pinkAccent.shade700),
                                  borderRadius: BorderRadius.circular(8))),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sayfa Sayısı",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                    Container(
                        height: 5.h,
                        width: 30.w,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: PagecountController,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.blueGrey)),
                              focusColor: Colors.pinkAccent,
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2, color: Colors.pinkAccent)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: Colors.pinkAccent.shade700),
                                  borderRadius: BorderRadius.circular(8))),
                        ))
                  ],
                ),
              ),
              normalButton(
                  child: Text("Kitabı Ekle"),
                  color: Colors.pinkAccent,
                  isLoading: isloading,
                  onPressed: () {
                    isloading = true;
                    if (booknameController.text != "" &&
                        selectedOption != null &&
                        selectedOption != "" &&
                        yayinameController != "" &&
                        PagecountController != "" &&
                        controller.image != null) {
                      controller.saveBook(
                          booknameController.text,
                          selectedOption!,
                          yayinameController.text,
                          writerController.text,
                          PagecountController.text);
                      isloading = false;
                      utils().showSnackBar(context, "Kitap Eklendi");
                    } else {
                      utils().showSnackBar(
                          context, "Bilgileri doğru girdiğinizden emin olun");
                      booknameController.text = "";
                      yayinameController.text = "";
                      writerController.text = "";
                      PagecountController.text = "";
                    }
                  },
                  width: 70.w,
                  height: 5.h)
            ],
          ),
        )
      ]),
    );
  }

  imageController controller = Get.put(imageController());
  XFile? _file;
  dynamic showbottom() {
    showModalBottomSheet(
      backgroundColor: Colors.pink.shade900,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      context: context,
      builder: (context) {
        return Container(
            height: 25.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ListTile(
                  onTap: () async {
                    final picker = ImagePicker();
                    XFile? pickedFile =
                        await picker.pickImage(source: ImageSource.camera);
                    _file = pickedFile;
                    controller.imageUpload(_file);
                    Navigator.pop(context);
                  },
                  selectedColor: Colors.cyan,
                  leading: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Kamerayı aç",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    final picker = ImagePicker();
                    XFile? pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    _file = pickedFile;
                    controller.imageUpload(_file);
                    Navigator.pop(context);
                  },
                  selectedColor: Colors.cyan,
                  leading: Icon(
                    Icons.photo,
                    color: Colors.white,
                    size: 40,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text("Galeriyi Aç",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                )
              ],
            ));
      },
    );
  }
}

class imageController extends GetxController {
  String? _imageUrl;
  String? get image => _imageUrl;
  String generateUniqueFileName() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  imageUpload(XFile? _file) async {
    if (_file != null) {
      Reference _profileREf =
          FirebaseStorage.instance.ref("images/${generateUniqueFileName()}");

      var _task = _profileREf.putFile(File(_file.path));

      _task.whenComplete(() async {
        _imageUrl = await _profileREf.getDownloadURL();
        update();
      });
    } else {
      // Kullanıcı fotoğraf yükleme işlemini başlatmadan geri döndü
      // Bu durumu uygun şekilde işleyebilirsiniz.
      print("Kullanıcı fotoğraf yükleme işlemini başlatmadan geri döndü.");
    }
    print(_imageUrl);
  }

  Future<void> saveBook(String bookname, String category, String publisher,
      String writer, String Pagecount) async {
    String uid = Uuid().v4();
    firestore.collection("books").doc(uid).set({
      "bookname": bookname,
      "publisher": publisher,
      "pagecount": int.tryParse(Pagecount),
      "uid": uid,
      "imageUrl": _imageUrl,
      "category": category,
      "writer": writer
    }, SetOptions(merge: true));
  }
}

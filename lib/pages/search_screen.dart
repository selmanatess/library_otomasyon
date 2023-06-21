import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_otomation/pages/book.dart';
import 'package:library_otomation/pages/homepage.dart';
import 'package:library_otomation/pages/searchbook.dart';
import 'package:library_otomation/widget/normal_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController textcontroller = TextEditingController();
  Stream<QuerySnapshot<Map<String, dynamic>>>? _stream;

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
  List<bool> isSelectedList = List.generate(10, (index) => false);
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
      _stream = FirebaseFirestore.instance.collection('books').snapshots();
    }

    @override
    void dispose() {
      textcontroller.dispose();
      textcontroller.dispose();
      super.dispose();
    }

    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      const BoxShadow(
                          color: Colors.grey, blurRadius: 8, spreadRadius: 2)
                    ],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                        width: 2, color: Colors.pinkAccent.shade400)),
                height: 7.h,
                width: 90.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: 6.h,
                        width: 50.w,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: TextField(
                            controller: textcontroller,
                            onChanged: (value) {
                              setState(() {
                                _stream = FirebaseFirestore.instance
                                    .collection('books')
                                    .where('bookname',
                                        isGreaterThanOrEqualTo: value)
                                    .snapshots();
                              });
                            },
                            cursorColor: Colors.pinkAccent,
                            decoration: InputDecoration(
                                hintText: "Kitap Arayın..",
                                border: InputBorder.none),
                          ),
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.search,
                          size: 32,
                          color: Colors.pinkAccent.shade700,
                        ))
                  ],
                ),
              ),
            ),
            StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text("hata${snapshot.error}");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(
                    color: Colors.pinkAccent,
                  );
                }
                if (snapshot.hasData) {
                  final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                      filteredDocs = snapshot.data!.docs.where((doc) {
                    final String name =
                        doc.get('bookname').toString().toLowerCase();
                    final String searchValue =
                        textcontroller.text.toLowerCase();
                    return name.contains(searchValue);
                  }).toList();

                  return Container(
                    width: 90.w,
                    height: 30.h,
                    child: ListView.builder(
                      itemCount: filteredDocs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Map<String, dynamic> data =
                            filteredDocs[index].data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListTile(
                            onTap: () {},
                            subtitle: Text(data['writer']),
                            title: Text(data['bookname']),
                            leading:
                                Image(image: NetworkImage(data["imageUrl"])),
                            // Diğer özellikleri burada görüntüleyebilirsiniz
                          ),
                        );
                      },
                    ),
                  );
                } else
                  return Container();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Aramak istediğiniz türü seçin",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              width: 90.w,
              height: 55.h,
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 4 / 3.5,
                      mainAxisSpacing: 15,
                      crossAxisSpacing: 15),
                  itemCount: options.length,
                  itemBuilder: (context, index) => normalButton(
                      child: Text(options[index]),
                      color: isSelectedList[index] == true
                          ? Colors.teal
                          : Colors.pinkAccent,
                      isLoading: false,
                      onPressed: () {
                        setState(() {
                          isSelectedList[index] = !isSelectedList[index];
                        });
                      },
                      width: 35.w,
                      height: 8.h)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Aradığınız kitabın sayfa aralığını girin",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
              ),
            ),
            Container(
              width: 90.w,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Min"),
                      Container(
                        width: 30.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(width: 2, color: Colors.pinkAccent)),
                        child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            controller: minpage,
                            decoration: InputDecoration(
                                hintText: "En az", border: InputBorder.none)),
                        height: 5.h,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text("Max"),
                      Container(
                        width: 30.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border:
                                Border.all(width: 2, color: Colors.pinkAccent)),
                        child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            controller: maxpage,
                            decoration: InputDecoration(
                                hintText: "En fazla",
                                border: InputBorder.none)),
                        height: 5.h,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: normalButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Kitabı bul  ",
                              style: TextStyle(
                                  fontSize: 21, color: Colors.pinkAccent),
                            ),
                            Icon(
                              Icons.search,
                              color: Colors.pinkAccent,
                              size: 40,
                            )
                          ],
                        ),
                        color: Colors.pink.shade50,
                        isLoading: false,
                        onPressed: () {
                          if (minpage.text != "" && maxpage.text != "") {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchBook(
                                      maxpage: int.parse(maxpage.text),
                                      minpage: int.parse(minpage.text),
                                      isSelectedList: isSelectedList),
                                ));
                          }
                        },
                        width: 50.w,
                        height: 7.h),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  TextEditingController minpage = TextEditingController();
  TextEditingController maxpage = TextEditingController();
}

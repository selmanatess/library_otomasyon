import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:library_otomation/pages/addbookScreen.dart';
import 'package:library_otomation/pages/bookScreen.dart';
import 'package:library_otomation/pages/borrowscreen.dart';
import 'package:library_otomation/pages/search_screen.dart';
import 'package:library_otomation/widget/bookCard.dart';
import 'package:library_otomation/widget/normal_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

int selecteditem = 0;
List tabs = [bookScreen(), SearchScreen(), AddbookScreen()];
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        actions: [
          Container(
              child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(auth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!["name"],
                        style: TextStyle(fontSize: 22),
                      );
                    } else
                      return CircularProgressIndicator();
                  },
                )
              ],
            ),
          ))
        ],
        backgroundColor: Colors.pinkAccent.shade700,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.blueAccent.shade700, Colors.pink],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              child: Text(
                'Kütüphane Ödünç Kitap Sistemine Hoş Geldiniz',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            ListTile(
              leading: Container(
                height: 40,
                width: 40,
                child: Image(image: AssetImage("assets/img/book.png")),
              ),
              title: Text('Aldığım Kitaplar'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BorrowScreen(),
                    ));
              },
            ),
            SizedBox(
              height: 45.h,
            ),
            ListTile(
              trailing: Icon(Icons.output_rounded),
              title: Text('Çıkış Yap'),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
      ),
      body: tabs[selecteditem],
      bottomNavigationBar: BottomNavigationBar(
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          backgroundColor: Colors.pinkAccent.shade700,
          onTap: (value) {
            setState(() {
              selecteditem = value;
            });
          },
          currentIndex: selecteditem,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
              ),
              label: "Kitaplar",
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                ),
                label: "Kitap Ara"),
            BottomNavigationBarItem(
                icon: Icon(Icons.library_add_outlined),
                label: "Kitap Ekle/Çıkar")
          ]),
    );
  }
}

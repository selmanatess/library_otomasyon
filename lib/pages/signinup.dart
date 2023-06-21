import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_otomation/constant/utils.dart';
import 'package:library_otomation/pages/homepage.dart';
import 'package:library_otomation/pages/signupscreen.dart';
import 'package:library_otomation/widget/normal_button.dart';
import 'package:library_otomation/widget/textediting.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SiginUP extends StatefulWidget {
  const SiginUP({super.key});

  @override
  State<SiginUP> createState() => _SiginUPState();
}

class _SiginUPState extends State<SiginUP> {
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    TextEditingController emailcontroller = TextEditingController();
    TextEditingController passwordcontroller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade700,
        title: Text("Kütüphane Rezervasyon Sistemi"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 30.h,
              width: 90.w,
              child: Image(image: AssetImage("assets/img/book.png")),
            ),
          ),
          textfieldWidget(
              obsourcetext: false,
              hintext: "E-mail Girin",
              controller: emailcontroller,
              keyboardType: TextInputType.text),
          textfieldWidget(
              obsourcetext: true,
              hintext: "Şifre girin",
              controller: passwordcontroller,
              keyboardType: TextInputType.text),
          SizedBox(
            height: 6.h,
          ),
          normalButton(
              child: Text("Giriş Yap"),
              color: Colors.pinkAccent.shade400,
              isLoading: false,
              onPressed: () async {
                if (emailcontroller.text != "" &&
                    passwordcontroller.text != "") {
                  setState(() {
                    isloading = true;
                  });
                  String output = await signinUser(
                      email: emailcontroller.text,
                      password: passwordcontroller.text);
                  setState(() {
                    false;
                  });
                  if (output == "Giriş başarılı") {
                    // ignore: use_build_context_synchronously
                    Navigator.push(context,
                        MaterialPageRoute(builder: (ctxt) => HomePage()));
                  } else {
                    //hata mesajını ekrana yazdırdım
                    // ignore: use_build_context_synchronously
                    utils().showSnackBar(context, output);
                  }
                } else
                  utils().showSnackBar(context, "Lütfen bilgileri girin");
              },
              width: 60.w,
              height: 10.h),
          Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Hesabın yok mu?"),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ));
                    },
                    child: Text("Kayıt Oluştur"))
              ],
            ),
          )
        ]),
      ),
    );
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> signinUser(
      {required String email, required String password}) async {
    email.trim();
    password.trim();
    String output = "Bir şeyler yanlış gitti";
    // ignore: avoid_print
    print(email);
    if (email != "" && password != "") {
      try {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        output = "Giriş başarılı";
      } catch (e) {
        {
          output = "Tekrar Deneyin";
        }
      }
    } else {
      output = "Bilgileri doğru girdiğiniden emin olun";
    }
    return output;
  }
}

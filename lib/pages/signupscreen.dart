import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_otomation/constant/utils.dart';
import 'package:library_otomation/models/usermodel.dart';
import 'package:library_otomation/pages/signinup.dart';
import 'package:library_otomation/widget/normal_button.dart';
import 'package:library_otomation/widget/textediting.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController namecontroller = TextEditingController();
    TextEditingController emailcontroller = TextEditingController();
    TextEditingController passwordcontroller = TextEditingController();
    TextEditingController classcontroller = TextEditingController();
    TextEditingController usernamecontroller = TextEditingController();
    bool isloading = false;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent.shade700,
        title: Text("Kayıt Olun"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 35.h,
              width: 60.w,
              child: Image(image: AssetImage("assets/img/pen.png")),
            ),
            textfieldWidget(
                obsourcetext: false,
                hintext: "Adınız Soyadınız",
                controller: namecontroller,
                keyboardType: TextInputType.text),
            textfieldWidget(
                obsourcetext: false,
                hintext: "E mail Adresiniz",
                controller: emailcontroller,
                keyboardType: TextInputType.text),
            textfieldWidget(
                obsourcetext: true,
                hintext: "Şifre Belirleyin ",
                controller: passwordcontroller,
                keyboardType: TextInputType.text),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: normalButton(
                  child: Text("Kayıt ol "),
                  color: Colors.pinkAccent.shade400,
                  isLoading: isloading,
                  onPressed: () async {
                    setState(() {
                      isloading = true;
                    });

                    print(namecontroller.text);
                    print(emailcontroller.text);
                    print(passwordcontroller.text);
                    print(classcontroller.text);

                    String output = await signupUser(
                      name: namecontroller.text,
                      email: emailcontroller.text,
                      password: passwordcontroller.text,
                    );
                    setState(() {
                      isloading = false;
                    });
                    if (output == "Kayıt başarılı") {
                      //kaydolduktan hemen sonra giriş ekranına yönetir

                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const SiginUP()));
                    } else {
                      utils().showSnackBar(context, output);
                    }
                  },
                  width: 70.w,
                  height: 7.h),
            )
          ],
        ),
      ),
    );
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> signupUser({
    required String name,
    required String email,
    required String password,
  }) async {
    name.trim();
    email.trim();
    password.trim();
    String output = "Lütfen bilgileri doldurduğunuzdan emin olun";
    if (name != "" && email != "" && password != "") {
      try {
        await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        UserModel user = UserModel(
          uid: auth.currentUser!.uid,
          name: name,
          email: email,
          password: password,
        );
        await firebaseFirestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .set(user.getJson(), SetOptions(merge: true));
        return output = "Kayıt Başarılı";
      } on FirebaseAuthException catch (e) {
        if (e.message.toString() ==
            "Password should be at least 6 characters") {
          output = "Lütfen daha güçlü şifre oluşturun!";
        }

        return output;
      }
    }
    return output = "Bilgileri doğru girdiğinizden emin olun";
  }
}

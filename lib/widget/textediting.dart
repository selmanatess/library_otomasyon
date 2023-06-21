import 'package:flutter/material.dart';

// ignore: camel_case_types
class textfieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool obsourcetext;
  final String hintext;
  final TextInputType keyboardType;
  const textfieldWidget(
      {super.key,
      required this.obsourcetext,
      required this.hintext,
      required this.controller,
      required this.keyboardType});

  @override
  State<textfieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<textfieldWidget> {
  late FocusNode focusNode;
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
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 40, left: 40),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey, boxShadow: [
          isInFocus
              ? const BoxShadow(
                  color: Color.fromARGB(255, 243, 82, 33),
                  blurRadius: 8,
                  spreadRadius: 2)
              : BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 2)
        ]),
        child: TextField(
            keyboardType: TextInputType.text,
            controller: widget.controller,
            focusNode: FocusNode(),
            obscureText: widget.obsourcetext,
            maxLines: 1,
            decoration: InputDecoration(
                fillColor: Colors.grey[100],
                filled: true,
                hintText: widget.hintext,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: const BorderSide(color: Colors.grey, width: 1)),
                focusedBorder: const OutlineInputBorder(
                    //text kenarlık rengi
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 255, 39, 39), width: 1)))),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class normalButton extends StatelessWidget {
  normalButton(
      {Key? key,
      required this.child,
      required this.color,
      required this.isLoading,
      required this.onPressed,
      required this.width,
      required this.height})
      : super(key: key);
  final double width;
  final double height;
  final Widget child;
  final Color color;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.circular(15)),
          backgroundColor: color,
          fixedSize: Size(width, height)),
      child: !isLoading
          ? child
          : const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}

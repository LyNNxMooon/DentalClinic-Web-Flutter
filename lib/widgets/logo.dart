import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Image.asset(
        "assets/images/dental.png",
        fit: BoxFit.fill,
      ),
    );
  }
}

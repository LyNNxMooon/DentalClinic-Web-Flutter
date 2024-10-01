import 'package:dental_clinic/screens/about_screen/about_screen.dart';
import 'package:dental_clinic/screens/home_screen/home_screen.dart';
import 'package:dental_clinic/widgets/navigation_bar_desktop.dart';
import 'package:flutter/material.dart';

class DesktopContactScreen extends StatelessWidget {
  const DesktopContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DesktopNavigationBar(
              title1: "Home",
              title2: "About",
              widget1: HomeScreen(),
              widget2: AboutScreen(),
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              "Contact Us!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

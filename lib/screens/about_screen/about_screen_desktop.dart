import 'package:dental_clinic/screens/contact_screen/contact_screen.dart';
import 'package:dental_clinic/screens/home_screen/home_screen.dart';
import 'package:dental_clinic/widgets/navigation_bar_desktop.dart';
import 'package:flutter/material.dart';

class DesktopAboutScreen extends StatelessWidget {
  const DesktopAboutScreen({super.key});

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
              title2: "Contact Us",
              widget1: HomeScreen(),
              widget2: ContactScreen(),
            ),
            SizedBox(
              height: 70,
            ),
            Text(
              "About Us!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:dental_clinic/screens/about_screen/about_screen.dart';
import 'package:dental_clinic/screens/contact_screen/contact_screen.dart';
import 'package:dental_clinic/widgets/navigation_bar_desktop.dart';
import 'package:flutter/material.dart';

class DesktopHomeScreen extends StatelessWidget {
  const DesktopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          children: [
            DesktopNavigationBar(
              title1: "About",
              title2: "Contact Us",
              widget1: AboutScreen(),
              widget2: ContactScreen(),
            )
          ],
        ),
      ),
    );
  }
}

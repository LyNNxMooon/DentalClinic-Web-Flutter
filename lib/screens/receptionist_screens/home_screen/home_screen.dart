import 'package:dental_clinic/responsive/responsive_layout.dart';
import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen_desktop.dart';
import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen_mobile.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileBody: MobileHomeScreen(), desktopBody: DesktopHomeScreen()),
    );
  }
}

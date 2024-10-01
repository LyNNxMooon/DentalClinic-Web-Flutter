import 'package:dental_clinic/responsive/responsive_layout.dart';
import 'package:dental_clinic/screens/about_screen/about_screen_desktop.dart';
import 'package:dental_clinic/screens/about_screen/about_screen_mobile.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileBody: MobileAboutScreen(), desktopBody: DesktopAboutScreen()),
    );
  }
}

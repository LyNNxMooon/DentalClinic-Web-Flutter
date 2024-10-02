import 'package:dental_clinic/responsive/responsive_layout.dart';
import 'package:dental_clinic/screens/patient_screens/contact_screen/contact_screen_desktop.dart';
import 'package:dental_clinic/screens/patient_screens/contact_screen/contact_screen_mobile.dart';
import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileBody: MobileContactScreen(),
          desktopBody: DesktopContactScreen()),
    );
  }
}

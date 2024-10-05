import 'package:dental_clinic/responsive/responsive_layout.dart';
import 'package:dental_clinic/screens/receptionist_screens/login_screens/login_screen_desktop.dart';
import 'package:dental_clinic/screens/receptionist_screens/login_screens/login_screen_mobile.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileBody: MobileLoginScreen(), desktopBody: DesktopLoginScreen()),
    );
  }
}

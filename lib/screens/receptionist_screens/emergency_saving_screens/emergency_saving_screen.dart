import 'package:dental_clinic/responsive/responsive_layout.dart';
import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_screens/emergency_saving_screen_desktop.dart';
import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_screens/emergency_saving_screen_mobile.dart';
import 'package:flutter/material.dart';

class EmergencySavingScreen extends StatelessWidget {
  const EmergencySavingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileBody: MobileEmergencySavingScreen(),
          desktopBody: DesktopEmergencySavingScreen()),
    );
  }
}

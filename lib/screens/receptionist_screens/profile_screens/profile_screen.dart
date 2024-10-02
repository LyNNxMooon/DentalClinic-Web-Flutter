import 'package:dental_clinic/responsive/responsive_layout.dart';

import 'package:dental_clinic/screens/receptionist_screens/profile_screens/profile_screen_mobile.dart';
import 'package:dental_clinic/screens/receptionist_screens/profile_screens/profile_screen_desktop.dart';
import 'package:flutter/material.dart';

class ReceptionistProfileScreen extends StatelessWidget {
  const ReceptionistProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileBody: MobileReceptionistProfileScreen(),
          desktopBody: DesktopReceptionistProfileScreen()),
    );
  }
}

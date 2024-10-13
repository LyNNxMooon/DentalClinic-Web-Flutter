import 'package:dental_clinic/responsive/responsive_layout.dart';

import 'package:dental_clinic/screens/receptionist_screens/treatment_management_screens/treatment_management_desktop_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/treatment_management_screens/treatment_management_mobile_screen.dart';
import 'package:flutter/material.dart';

class TreatmentManagementScreen extends StatelessWidget {
  const TreatmentManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileBody: MobileTreatmentManagementScreen(),
          desktopBody: DesktopTreatmentManagementScreen()),
    );
  }
}

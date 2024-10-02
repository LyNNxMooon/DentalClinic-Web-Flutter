import 'package:dental_clinic/responsive/responsive_layout.dart';
import 'package:dental_clinic/screens/receptionist_screens/patient_management_screens/patient_management_screen_desktop.dart';
import 'package:dental_clinic/screens/receptionist_screens/patient_management_screens/patient_management_screen_mobile.dart';
import 'package:flutter/material.dart';

class PatientManagementScreen extends StatelessWidget {
  const PatientManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileBody: MobilePatientManagementScreen(),
          desktopBody: DesktopPatientManagementScreen()),
    );
  }
}

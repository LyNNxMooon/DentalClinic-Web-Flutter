import 'package:dental_clinic/responsive/responsive_layout.dart';
import 'package:dental_clinic/screens/receptionist_screens/add_treatment_screens/add_treatment_desktop_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/add_treatment_screens/add_treatment_mobile_screen.dart';
import 'package:flutter/material.dart';

class AddTreatmentScreen extends StatelessWidget {
  const AddTreatmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileBody: MobileAddTreatmentScreen(),
          desktopBody: DesktopAddTreatmentScreen()),
    );
  }
}

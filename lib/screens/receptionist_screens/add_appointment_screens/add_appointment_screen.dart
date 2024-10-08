import 'package:dental_clinic/responsive/responsive_layout.dart';
import 'package:dental_clinic/screens/receptionist_screens/add_appointment_screens/add_appointment_desktop_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/add_appointment_screens/add_appointment_mobile_screen.dart';
import 'package:flutter/material.dart';

class AddAppointmentScreen extends StatelessWidget {
  const AddAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileBody: AddAppointmentMobileScreen(),
          desktopBody: AddAppointmentDesktopScreen()),
    );
  }
}

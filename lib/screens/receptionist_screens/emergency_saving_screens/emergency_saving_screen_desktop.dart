import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/patient_management_screens/patient_management_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/profile_screens/profile_screen.dart';
import 'package:dental_clinic/widgets/navigation_bar_desktop.dart';
import 'package:flutter/material.dart';

class DesktopEmergencySavingScreen extends StatelessWidget {
  const DesktopEmergencySavingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DesktopNavigationBar(
              title1: "Home",
              title2: "Patients",
              icon: Icons.person_outline,
              widget1: HomeScreen(),
              widget2: PatientManagementScreen(),
              widget3: ReceptionistProfileScreen(),
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              "Emergency Saving",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

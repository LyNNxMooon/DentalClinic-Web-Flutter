import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_screens/emergency_saving_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/patient_management_screens/patient_management_screen.dart';
import 'package:dental_clinic/widgets/navigation_bar_desktop.dart';
import 'package:flutter/material.dart';

class DesktopReceptionistProfileScreen extends StatelessWidget {
  const DesktopReceptionistProfileScreen({super.key});

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
              icon: Icons.health_and_safety_rounded,
              widget1: HomeScreen(),
              widget2: PatientManagementScreen(),
              widget3: EmergencySavingScreen(),
            ),
            SizedBox(
              height: 60,
            ),
            Text(
              "Profile",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

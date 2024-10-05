import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/patient_management_screens/patient_management_screen.dart';

import 'package:dental_clinic/widgets/navigation_bar_mobile.dart';
import 'package:flutter/material.dart';

class MobileEmergencySavingScreen extends StatefulWidget {
  const MobileEmergencySavingScreen({super.key});

  @override
  State<MobileEmergencySavingScreen> createState() =>
      _MobileEmergencySavingScreenState();
}

class _MobileEmergencySavingScreenState
    extends State<MobileEmergencySavingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const Drawer(
          backgroundColor: kPrimaryColor,
          child: CustomNavigationDrawer(
            title1: "Home",
            title2: "Patients",
            widget1: HomeScreen(),
            widget2: PatientManagementScreen(),
          )),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MobileNavigationBar(
              scaffoldKey: _scaffoldKey,
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              textAlign: TextAlign.start,
              "Emergency Saving",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

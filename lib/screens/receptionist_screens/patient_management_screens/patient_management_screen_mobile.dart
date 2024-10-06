import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_screens/emergency_saving_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/profile_screens/profile_screen.dart';

import 'package:dental_clinic/widgets/navigation_bar_mobile.dart';
import 'package:flutter/material.dart';

class MobilePatientManagementScreen extends StatefulWidget {
  const MobilePatientManagementScreen({super.key});

  @override
  State<MobilePatientManagementScreen> createState() =>
      _MobilePatientManagementScreenState();
}

class _MobilePatientManagementScreenState
    extends State<MobilePatientManagementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const Drawer(
          backgroundColor: kPrimaryColor,
          child: CustomNavigationDrawer(
            title1: "Home",
            title2: "Emergency",
            title3: "Profile",
            icon1: Icons.home,
            icon2: Icons.emergency_outlined,
            icon3: Icons.person,
            widget1: HomeScreen(),
            widget2: EmergencySavingScreen(),
            widget3: ReceptionistProfileScreen(),
          )),
      body: Padding(
        padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MobileNavigationBar(
              scaffoldKey: _scaffoldKey,
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  textAlign: TextAlign.start,
                  "Manage Patients",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(6)),
                    child: const Center(
                      child: Icon(Icons.add),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

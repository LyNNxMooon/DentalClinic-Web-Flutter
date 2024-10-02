import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/profile_screens/profile_screen.dart';
import 'package:dental_clinic/widgets/navigation_bar_desktop.dart';
import 'package:flutter/material.dart';

class DesktopPatientManagementScreen extends StatelessWidget {
  const DesktopPatientManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const DesktopNavigationBar(
              title1: "Home",
              title2: "Profile",
              widget1: HomeScreen(),
              widget2: ReceptionistProfileScreen(),
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Manage Patients",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 80,
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

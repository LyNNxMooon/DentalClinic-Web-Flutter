import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/screens/contact_screen/contact_screen.dart';
import 'package:dental_clinic/screens/home_screen/home_screen.dart';

import 'package:dental_clinic/widgets/navigation_bar_mobile.dart';
import 'package:flutter/material.dart';

class MobileAboutScreen extends StatefulWidget {
  const MobileAboutScreen({super.key});

  @override
  State<MobileAboutScreen> createState() => _MobileAboutScreenState();
}

class _MobileAboutScreenState extends State<MobileAboutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const Drawer(
          backgroundColor: kPrimaryColor,
          child: CustomNavigationDrawer(
            title1: "Home",
            title2: "Contact Us",
            widget1: HomeScreen(),
            widget2: ContactScreen(),
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
              "About Us!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

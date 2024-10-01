import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/screens/about_screen/about_screen.dart';
import 'package:dental_clinic/screens/home_screen/home_screen.dart';

import 'package:dental_clinic/widgets/navigation_bar_mobile.dart';
import 'package:flutter/material.dart';

class MobileContactScreen extends StatefulWidget {
  const MobileContactScreen({super.key});

  @override
  State<MobileContactScreen> createState() => _MobileContactScreenState();
}

class _MobileContactScreenState extends State<MobileContactScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const Drawer(
          backgroundColor: kPrimaryColor,
          child: CustomNavigationDrawer(
            title1: "Home",
            title2: "About",
            widget1: HomeScreen(),
            widget2: AboutScreen(),
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
              "Contact Us!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

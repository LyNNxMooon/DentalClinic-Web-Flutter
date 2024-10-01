import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/screens/about_screen/about_screen.dart';
import 'package:dental_clinic/screens/contact_screen/contact_screen.dart';

import 'package:dental_clinic/widgets/navigation_bar_mobile.dart';
import 'package:flutter/material.dart';

class MobileHomeScreen extends StatefulWidget {
  const MobileHomeScreen({super.key});

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const Drawer(
          backgroundColor: kPrimaryColor,
          child: CustomNavigationDrawer(
            title1: "About",
            title2: "Contact us",
            widget1: AboutScreen(),
            widget2: ContactScreen(),
          )),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: MobileNavigationBar(
          scaffoldKey: _scaffoldKey,
        ),
      ),
    );
  }
}

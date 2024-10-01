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
        child: SingleChildScrollView(
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
                "Available Doctors",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 230,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 0.0,
                    mainAxisExtent: 220,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) => doctorCard(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget doctorCard(BuildContext context) {
  return Container(
    margin: const EdgeInsets.all(7),
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      border: Border.all(width: 0.5),
      borderRadius: BorderRadius.circular(8), //border corner radius
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(45),
                border: Border.all(width: 0.3)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: Image.asset(
                "assets/images/doctor_placeholder.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          "Doctor's Name",
          style: TextStyle(fontSize: 15),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "Specialist",
          style: TextStyle(fontSize: 12, color: kThirdColor),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "Experience",
          style: TextStyle(fontSize: 12, color: kThirdColor),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "Day Off",
          style: TextStyle(fontSize: 12, color: kThirdColor),
        ),
      ],
    ),
  );
}

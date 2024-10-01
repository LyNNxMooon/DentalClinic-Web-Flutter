import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/screens/about_screen/about_screen.dart';
import 'package:dental_clinic/screens/contact_screen/contact_screen.dart';
import 'package:dental_clinic/widgets/navigation_bar_desktop.dart';
import 'package:flutter/material.dart';

class DesktopHomeScreen extends StatelessWidget {
  const DesktopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const DesktopNavigationBar(
                title1: "About",
                title2: "Contact Us",
                widget1: AboutScreen(),
                widget2: ContactScreen(),
              ),
              const SizedBox(
                height: 60,
              ),
              const Text(
                "Available Doctors",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 300,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 15,
                  ),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      GestureDetector(onTap: () {}, child: doctorCard(context)),
                  itemCount: 10,
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
    width: 200,
    decoration: BoxDecoration(
        border: Border.all(width: 1), borderRadius: BorderRadius.circular(10)),
    padding: const EdgeInsets.all(15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55),
                border: Border.all(width: 0.3)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(55),
              child: Image.asset(
                "assets/images/doctor_placeholder.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 35,
        ),
        const Text(
          "Doctor's Name",
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Specialist",
          style: TextStyle(fontSize: 14, color: kThirdColor),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Experience",
          style: TextStyle(fontSize: 14, color: kThirdColor),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Day Off",
          style: TextStyle(fontSize: 14, color: kThirdColor),
        ),
      ],
    ),
  );
}

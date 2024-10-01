import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/widgets/logo.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileNavigationBar extends StatefulWidget {
  const MobileNavigationBar({
    super.key,
    required this.scaffoldKey,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<MobileNavigationBar> createState() => _MobileNavigationBarState();
}

class _MobileNavigationBarState extends State<MobileNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppLogo(),
        IconButton(
            onPressed: () => widget.scaffoldKey.currentState!.openEndDrawer(),
            icon: const Icon(Icons.menu))
      ],
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem(
      {super.key,
      required this.title,
      required this.icon,
      required this.widget});

  final String title;
  final IconData icon;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 60),
      child: GestureDetector(
        onTap: () {
          Get.offAll(() => widget);
        },
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 20,
            ),
            Text(title)
          ],
        ),
      ),
    );
  }
}

class CustomNavigationDrawer extends StatelessWidget {
  const CustomNavigationDrawer(
      {super.key,
      required this.title1,
      required this.title2,
      required this.widget1,
      required this.widget2});

  final String title1;
  final String title2;
  final Widget widget1;
  final Widget widget2;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 140,
          color: kSecondaryColor,
          child: const Center(
            child: Text(
              "Dental Clinic",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        DrawerItem(
          title: title1,
          icon: Icons.question_mark_rounded,
          widget: widget1,
        ),
        const SizedBox(
          height: 10,
        ),
        DrawerItem(
          title: title2,
          icon: Icons.phone,
          widget: widget2,
        )
      ],
    );
  }
}

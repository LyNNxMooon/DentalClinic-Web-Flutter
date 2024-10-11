import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/utils/hover_extensions.dart';
import 'package:dental_clinic/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesktopNavigationBar extends StatelessWidget {
  const DesktopNavigationBar(
      {super.key,
      required this.title1,
      required this.title2,
      required this.widget1,
      required this.widget2,
      required this.icon,
      required this.widget3});

  final String title1;
  final String title2;
  final IconData icon;
  final Widget widget1;
  final Widget widget2;
  final Widget widget3;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            AppLogo(),
            SizedBox(
              width: 20,
            ),
            Text(
              "Dental Clinic",
              style: mobileTitleStyle,
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.offAll(() => widget1);
              },
              child: Text(
                title1,
                style: const TextStyle(fontSize: 16),
              ),
            ).showCursorOnHover.moveUpOnHover,
            const SizedBox(
              width: 23,
            ),
            GestureDetector(
              onTap: () {
                Get.offAll(() => widget2);
              },
              child: Text(
                title2,
                style: const TextStyle(fontSize: 16),
              ),
            ).showCursorOnHover.moveUpOnHover,
            const SizedBox(
              width: 10,
            ),
            IconButton(
                    onPressed: () {
                      Get.offAll(() => widget3);
                    },
                    icon: Icon(icon))
                .showCursorOnHover
          ],
        )
      ],
    );
  }
}

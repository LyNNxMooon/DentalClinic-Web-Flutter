import 'package:dental_clinic/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesktopNavigationBar extends StatelessWidget {
  const DesktopNavigationBar(
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
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Dental Clinic",
          style: desktopTitleStyle,
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
            ),
            const SizedBox(
              width: 25,
            ),
            GestureDetector(
              onTap: () {
                Get.offAll(() => widget2);
              },
              child: Text(
                title2,
                style: const TextStyle(fontSize: 16),
              ),
            )
          ],
        )
      ],
    );
  }
}

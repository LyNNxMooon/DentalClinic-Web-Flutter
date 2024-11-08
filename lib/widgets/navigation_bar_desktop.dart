import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen.dart';
import 'package:dental_clinic/utils/hover_extensions.dart';
import 'package:dental_clinic/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesktopNavigationBar extends StatefulWidget {
  const DesktopNavigationBar(
      {super.key,
      required this.title1,
      required this.title2,
      required this.widget1,
      required this.widget2,
      required this.icon,
      required this.widget3,
      required this.icon2,
      required this.widget4});

  final String title1;
  final String title2;
  final IconData icon;
  final IconData icon2;
  final Widget widget1;
  final Widget widget2;
  final Widget widget3;
  final Widget widget4;

  @override
  State<DesktopNavigationBar> createState() => _DesktopNavigationBarState();
}

class _DesktopNavigationBarState extends State<DesktopNavigationBar> {
  bool _isHoverItem = false;
  bool _isHoverItem2 = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Get.offAll(() => const HomeScreen()),
          child: const Row(
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
          ).showCursorOnHover,
        ),
        Row(
          children: [
            MouseRegion(
              onEnter: (_) => setState(() => _isHoverItem = true),
              onExit: (_) => setState(() => _isHoverItem = false),
              child: GestureDetector(
                onTap: () {
                  Get.offAll(() => widget.widget1);
                },
                child: Column(
                  children: [
                    Text(
                      widget.title1,
                      style: const TextStyle(fontSize: 16),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 2,
                      width: _isHoverItem ? 60 : 0, // Underline width on hover
                      color: kFourthColor, // Underline color
                    ),
                  ],
                ),
              ).showCursorOnHover,
            ),
            const SizedBox(
              width: 23,
            ),
            MouseRegion(
              onEnter: (_) => setState(() => _isHoverItem2 = true),
              onExit: (_) => setState(() => _isHoverItem2 = false),
              child: GestureDetector(
                onTap: () {
                  Get.offAll(() => widget.widget2);
                },
                child: Column(
                  children: [
                    Text(
                      widget.title2,
                      style: const TextStyle(fontSize: 16),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 2,
                      width: _isHoverItem2 ? 60 : 0, // Underline width on hover
                      color: kFourthColor, // Underline color
                    ),
                  ],
                ),
              ).showCursorOnHover,
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
                    onPressed: () {
                      Get.offAll(() => widget.widget3);
                    },
                    icon: Icon(widget.icon))
                .showCursorOnHover,
            const SizedBox(
              width: 10,
            ),
            IconButton(
                    onPressed: () {
                      Get.offAll(() => widget.widget4);
                    },
                    icon: Icon(widget.icon2))
                .showCursorOnHover
          ],
        )
      ],
    );
  }
}

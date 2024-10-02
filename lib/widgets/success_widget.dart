import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dental_clinic/constants/colors.dart';

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Get.back();
              },
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(kSecondaryColor)),
              child: const Text(
                "OK",
                style: TextStyle(color: kPrimaryColor),
              ),
            ),
          )
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: kSuccessColor,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: kFourthColor),
            ),
          ],
        ));
  }
}

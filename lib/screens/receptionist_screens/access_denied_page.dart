import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/screens/receptionist_screens/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccessDeniedPage extends StatelessWidget {
  const AccessDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: kErrorColor,
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Your Access is Denied!",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kErrorColor),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
                onPressed: () {
                  Get.offAll(() => const AuthPage());
                },
                child: const Text(
                  "Ok",
                  style: TextStyle(color: kFourthColor),
                ))
          ],
        ),
      ),
    );
  }
}

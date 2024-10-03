import 'package:dental_clinic/constants/colors.dart';
import 'package:flutter/material.dart';

class NoConnectionMobileWidget extends StatelessWidget {
  const NoConnectionMobileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "404",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 40,
                color: kSecondaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Center(
          child: Text(
            textAlign: TextAlign.center,
            "Unable to connect to server",
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }
}

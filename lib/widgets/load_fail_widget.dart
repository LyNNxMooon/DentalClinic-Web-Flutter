import 'package:dental_clinic/constants/text.dart';
import 'package:flutter/material.dart';

import 'package:dental_clinic/constants/colors.dart';

class LoadFailWidget extends StatelessWidget {
  const LoadFailWidget({super.key, required this.function});

  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "No Data Available",
          style: desktopTitleStyle,
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
            child: GestureDetector(
          onTap: function,
          child: const Text(
            "Try Again",
            style: TextStyle(
                color: kSecondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ))
      ],
    );
  }
}

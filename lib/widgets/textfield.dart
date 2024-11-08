import 'package:dental_clinic/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:dental_clinic/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hintText,
      required this.label,
      this.isObsecure,
      this.suffixIcon,
      this.minLines,
      this.maxLines,
      this.validator,
      this.keyboardType,
      required this.controller});

  final String hintText;
  final String label;
  final bool? isObsecure;
  final IconButton? suffixIcon;
  final TextEditingController controller;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final Validator? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        obscureText: isObsecure ?? false,
        controller: controller,
        minLines: minLines,
        keyboardType: keyboardType,
        maxLines: maxLines,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator != null
            ? () {
                switch (validator) {
                  case Validator.email:
                    return (value) => TextFieldValidator.email(value);

                  case Validator.phone:
                    return (value) => TextFieldValidator.phone(value, context);

                  default:
                    return (value) => TextFieldValidator.defaultEnterV(value);
                }
              }()
            : null,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          hintText: hintText,
          labelText: label,
          labelStyle: const TextStyle(color: kFourthColor),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: kFourthColor),
              borderRadius: BorderRadius.circular(10)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: kFourthColor, width: 1),
              borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: kFourthColor),
              borderRadius: BorderRadius.circular(10)),
        ));
  }
}

class TextFieldValidator {
  static String? phone(String? phone, BuildContext context) {
    String pattern = r'^(?:[+0]9)?[0-9]{9,12}$';

    RegExp regExp = RegExp(
      pattern,
    );
    if (phone!.isEmpty) {
      return 'Please enter Phone Number !';
    } else if (!regExp.hasMatch(phone)) {
      return "Please enter validate Phone Number !";
    }
    return null;
  }

  static String? email(String? email) {
    RegExp regExp = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (email!.isEmpty) {
      return null;
    } else if (!regExp.hasMatch(email)) {
      return "Please enter valid email !";
    }
    return null;
  }

  static String? defaultEnterV([dynamic value, String? validateName]) {
    if (value is String && value.isEmpty) {
      return '$validateName';
    }
    return null;
  }
}

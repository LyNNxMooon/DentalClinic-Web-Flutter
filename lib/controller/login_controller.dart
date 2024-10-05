// ignore_for_file: use_build_context_synchronously

import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:dental_clinic/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  final _firebaseService = FirebaseServices();

  Future login(String email, String password, BuildContext context) async {
    setLoadingState = LoadingState.loading;

    return _firebaseService.firebaseSignIn(email, password).then(
      (value) {
        setLoadingState = LoadingState.complete;
      },
    ).catchError((error) {
      setLoadingState = LoadingState.error;
      setErrorMessage = error.message;

      showDialog(
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
          function: () {
            Get.back();
          },
        ),
      );
    });
  }
}

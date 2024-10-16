// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/screens/receptionist_screens/access_denied_page.dart';

import 'package:dental_clinic/utils/enums.dart';
import 'package:dental_clinic/widgets/error_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  final _firebaseService = FirebaseServices();

  RxString adminEmail = "".obs;
  RxString adminPassword = "".obs;

  Future<bool> checkAdmin(
      String email, String password, BuildContext context) async {
    if (FirebaseAuth.instance.currentUser?.email != email) {
      return false;
    }
    return _firebaseService.firebaseSignIn(email, password).then(
      (value) {
        return true;
      },
    ).catchError((error) {
      return false;
    });
  }

  Future login(String email, String password, BuildContext context) async {
    setLoadingState = LoadingState.loading;

    _firebaseService.firebaseSignIn(email, password).then(
      (value) {
        String id = FirebaseAuth.instance.currentUser?.uid ?? '';

        _firebaseService.getPatient(id).then(
          (value) {
            if (value == null) {
              setLoadingState = LoadingState.complete;

              print("admin authenticated!");
            } else {
              setLoadingState = LoadingState.error;
              FirebaseAuth.instance.signOut();
              Get.offAll(() => const AccessDeniedPage());
            }
          },
        );
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

    update();
  }
}

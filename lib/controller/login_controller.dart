// ignore_for_file: use_build_context_synchronously, avoid_print, deprecated_member_use

import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/data/vos/admin_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/screens/receptionist_screens/access_denied_page.dart';

import 'package:dental_clinic/utils/enums.dart';
import 'package:dental_clinic/widgets/error_widget.dart';
import 'package:dental_clinic/widgets/success_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends BaseController {
  final _firebaseService = FirebaseServices();

  RxString adminEmail = "".obs;
  RxString adminPassword = "".obs;

  Future<bool> checkAdmin(String password, BuildContext context) async {
    String adminEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    return _firebaseService.firebaseSignIn(adminEmail, password).then(
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
              _firebaseService.deleteFormerAdmin().then(
                (value) {
                  final adminVo = AdminVO(id: id);
                  _firebaseService.saveAdmin(adminVo);
                },
              );

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

  // String generateOTP() {
  //   var random = Random();
  //   int otp = 100000 + random.nextInt(900000);
  //   return otp.toString();
  // }

  // Future<bool> checkIfEmailExists(String email) async {
  //   try {
  //     bool isExist = false;
  //     List<String> signInMethods = [];
  //     await FirebaseAuth.instance.fetchSignInMethodsForEmail(email).then(
  //       (value) {
  //         signInMethods = value;
  //         print(signInMethods);

  //         if (signInMethods.isEmpty) {
  //           isExist = false;
  //         } else {
  //           isExist = true;
  //         }
  //       },
  //     );

  //     return isExist;
  //   } catch (e) {
  //     print("Error checking email: $e");
  //     return false;
  //   }
  // }

  Future<void> resetPassword(String email, BuildContext context) async {
    setLoadingState = LoadingState.loading;

    if (email.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please input admin email.";

      showDialog(
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
          function: () {
            Get.back();
          },
        ),
      );
    } else {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then(
          (value) {
            setLoadingState = LoadingState.complete;
            showDialog(
              context: context,
              builder: (context) => const SuccessWidget(
                  message:
                      "Please check your admin Email. We have sent the password reset link"),
            );
          },
        );
      } catch (e) {
        setLoadingState = LoadingState.error;
        setErrorMessage = "$e";
        showDialog(
          context: context,
          builder: (context) => CustomErrorWidget(
            errorMessage: getErrorMessage,
            function: () {
              Get.back();
            },
          ),
        );
      }
    }
  }
}

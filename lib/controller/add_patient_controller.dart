// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/controller/login_controller.dart';
import 'package:dental_clinic/controller/patient_management_controller.dart';
import 'package:dental_clinic/data/vos/patient_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:dental_clinic/widgets/error_widget.dart';
import 'package:dental_clinic/widgets/success_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPatientController extends BaseController {
  final _firebaseService = FirebaseServices();
  Rxn<Uint8List> selectFile = Rxn<Uint8List>();
  final _patientManagementController = Get.put(PatientManagementController());

  final _loginController = Get.put(LoginController());

  Future registerPatients(
      TextEditingController email,
      TextEditingController password,
      TextEditingController name,
      TextEditingController age,
      String gender,
      BuildContext context) async {
    if (name.text.isEmpty ||
        email.text.isEmpty ||
        password.text.isEmpty ||
        age.text.isEmpty ||
        gender.isEmpty ||
        selectFile.value == null) {
      setLoadingState = LoadingState.error;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: "Fill all the fields!",
          function: () {
            Get.back();
          },
        ),
      );
    } else {
      setLoadingState = LoadingState.loading;
      String fileURL = await _uploadFileToFirebaseStorage();
      return _firebaseService.firebaseSignUp(email.text, password.text).then(
        (value) {
          String id = FirebaseAuth.instance.currentUser?.uid ?? '';
          final patientVo = PatientVO(
              id: id,
              name: name.text,
              isBanned: false,
              url: fileURL,
              age: int.parse(age.text),
              gender: gender);

          _firebaseService.savePatient(patientVo).then(
            (value) {
              setLoadingState = LoadingState.complete;

              showDialog(
                context: context,
                builder: (context) =>
                    const SuccessWidget(message: "New Patient Added!"),
              );

              selectFile.value = null;
              name.clear();
              age.clear();
              email.clear();
              password.clear();

              _patientManagementController.callPatients();
            },
          );

          FirebaseAuth.instance.signOut();

          _firebaseService.firebaseSignIn(_loginController.adminEmail.value,
              _loginController.adminPassword.value);
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

  Future _uploadFileToFirebaseStorage() {
    String path = 'image';
    String contentType = 'image/jpg';

    return FirebaseServices.uploadToFirebaseStorage(
        selectFile.value!, path, contentType);
  }
}

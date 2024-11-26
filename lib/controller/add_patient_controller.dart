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
      TextEditingController phone,
      TextEditingController address,
      TextEditingController allergicMedicine,
      String gender,
      BuildContext context) async {
    RegExp letterRegExp = RegExp(r'[a-zA-Z]');
    if (name.text.isEmpty &&
        email.text.isEmpty &&
        password.text.isEmpty &&
        age.text.isEmpty &&
        phone.text.isEmpty &&
        address.text.isEmpty &&
        gender.isEmpty &&
        selectFile.value == null) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please fill all the patient's information!";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
          function: () {
            Get.back();
          },
        ),
      );
    } else if (selectFile.value == null) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please upload patient's photo!";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
          function: () {
            Get.back();
          },
        ),
      );
    } else if (name.text.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter patient's name!";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
          function: () {
            Get.back();
          },
        ),
      );
    } else if (email.text.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter patient's email!";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
          function: () {
            Get.back();
          },
        ),
      );
    } else if (password.text.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter patient's default password!";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
          function: () {
            Get.back();
          },
        ),
      );
    } else if (age.text.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter patient's age!";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
          function: () {
            Get.back();
          },
        ),
      );
    } else if (letterRegExp.hasMatch(age.text)) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Patient age must be numbers!";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
          function: () {
            Get.back();
          },
        ),
      );
    } else if (phone.text.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter patient's phone!";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
          function: () {
            Get.back();
          },
        ),
      );
    } else if (letterRegExp.hasMatch(phone.text)) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Patient's phone must be numbers!";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
          function: () {
            Get.back();
          },
        ),
      );
    } else if (address.text.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter patient's address!";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
          function: () {
            Get.back();
          },
        ),
      );
    } else if (gender.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please select patient's gender!";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
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
              banReason: '',
              address: address.text,
              allergicMedicine:
                  allergicMedicine.text.isEmpty ? "Non" : allergicMedicine.text,
              phone: int.parse(phone.text),
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
              phone.clear();

              _patientManagementController.callPatients();
            },
          );

          FirebaseAuth.instance.signOut();

          _firebaseService.firebaseSignIn(_loginController.adminEmail.value,
              _loginController.adminPassword.value);
        },
      ).catchError((error) {
        _firebaseService.firebaseSignIn(email.text, password.text);
        FirebaseAuth.instance.currentUser?.delete().then(
          (value) {
            _firebaseService.firebaseSignIn(_loginController.adminEmail.value,
                _loginController.adminPassword.value);
          },
        );

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
    update();
  }

  Future _uploadFileToFirebaseStorage() {
    String path = 'image';
    String contentType = 'image/jpg';

    return FirebaseServices.uploadToFirebaseStorage(
        selectFile.value!, path, contentType);
  }
}

// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:typed_data';

import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/controller/receptionist_home_controller.dart';
import 'package:dental_clinic/data/vos/doctor_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:dental_clinic/widgets/error_widget.dart';
import 'package:dental_clinic/widgets/success_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDoctorController extends BaseController {
  Rxn<Uint8List> selectFile = Rxn<Uint8List>();

  final _firebaseService = FirebaseServices();
  final _receptionistHomeController = Get.put(ReceptionistHomeController());

  Future addDoctor(
      TextEditingController name,
      TextEditingController doctorId,
      TextEditingController bio,
      TextEditingController specialist,
      TextEditingController experience,
      Map<String, List> availability,
      BuildContext context) async {
    print(availability);
    bool hasWorkingHours = availability.values.any((times) => times.isNotEmpty);
    if (name.text.isEmpty &&
        doctorId.text.isEmpty &&
        bio.text.isEmpty &&
        specialist.text.isEmpty &&
        experience.text.isEmpty &&
        !hasWorkingHours &&
        selectFile.value == null) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please fill all the doctor's information!";
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
      setErrorMessage = "Please upload the doctor photo!";
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
      setErrorMessage = "Please enter doctor name!";
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
    } else if (doctorId.text.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter doctor ID!";
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
    } else if (bio.text.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter doctor's biography!";
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
    } else if (specialist.text.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter doctor's specialist!";
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
    } else if (experience.text.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter doctor's experience!";
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
    } else if (!hasWorkingHours) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please select doctor's working hours!";
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
      int id = DateTime.now().millisecondsSinceEpoch;

      String fileURL = await _uploadFileToFirebaseStorage();

      final doctor = DoctorVO(
          doctorID: doctorId.text,
          id: id,
          url: fileURL,
          name: name.text,
          bio: bio.text,
          specialist: specialist.text,
          experience: experience.text,
          availability: availability);
      return _firebaseService.saveDoctor(doctor).then(
        (value) {
          setLoadingState = LoadingState.complete;

          showDialog(
            context: context,
            builder: (context) =>
                const SuccessWidget(message: "New Doctor Added!"),
          );

          selectFile.value = null;
          name.clear();
          bio.clear();
          specialist.clear();
          experience.clear();
          doctorId.clear();

          _receptionistHomeController.callDoctors();
        },
      ).catchError((error) {
        print(error);
        setLoadingState = LoadingState.error;
        setErrorMessage = error;
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

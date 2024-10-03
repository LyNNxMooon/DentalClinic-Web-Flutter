// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:typed_data';

import 'package:dental_clinic/controller/base_controller.dart';
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

  Future addDoctor(
      TextEditingController name,
      TextEditingController bio,
      TextEditingController specialist,
      TextEditingController experience,
      TextEditingController dayOff,
      BuildContext context) async {
    if (name.text.isEmpty ||
        bio.text.isEmpty ||
        specialist.text.isEmpty ||
        experience.text.isEmpty ||
        dayOff.text.isEmpty ||
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
      int id = DateTime.now().millisecondsSinceEpoch;

      String fileURL = await _uploadFileToFirebaseStorage();

      final doctor = DoctorVO(
          id: id,
          url: fileURL,
          name: name.text,
          bio: bio.text,
          specialist: specialist.text,
          experience: experience.text,
          dayOff: dayOff.text);
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
          dayOff.clear();
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
  }

  Future _uploadFileToFirebaseStorage() {
    String path = 'image';
    String contentType = 'image/jpg';

    return FirebaseServices.uploadToFirebaseStorage(
        selectFile.value!, path, contentType);
  }
}

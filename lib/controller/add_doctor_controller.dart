// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/data/vos/doctor_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:dental_clinic/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddDoctorController extends BaseController {
  Uint8List? selectFile;

  final _firebaseService = FirebaseServices();

  Future addDoctor(String name, String bio, String specialist,
      String experience, String dayOff, BuildContext context) async {
    setLoadingState = LoadingState.loading;
    int id = DateTime.now().millisecondsSinceEpoch;

    String fileURL = await _uploadFileToFirebaseStorage();

    final doctor = DoctorVO(
        id: id,
        url: fileURL,
        name: name,
        bio: bio,
        specialist: specialist,
        experience: experience,
        dayOff: dayOff);
    return _firebaseService.saveDoctor(doctor).then(
      (value) {
        setLoadingState = LoadingState.complete;
      },
    ).catchError((error) {
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

  Future _uploadFileToFirebaseStorage() {
    String path = 'image';
    String contentType = 'image/jpg';

    return FirebaseServices.uploadToFirebaseStorage(
        selectFile!, path, contentType);
  }
}

// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:typed_data';

import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/controller/emergency_saving_controller.dart';
import 'package:dental_clinic/data/vos/emergency_saving_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:dental_clinic/widgets/error_widget.dart';
import 'package:dental_clinic/widgets/success_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEmergencySavingController extends BaseController {
  Rxn<Uint8List> selectFile = Rxn<Uint8List>();

  final _firebaseService = FirebaseServices();

  final _emergencySavingController = Get.put(EmergencySavingController());

  Future addEmergencySaving(TextEditingController title,
      TextEditingController body, BuildContext context) async {
    if (title.text.isEmpty || body.text.isEmpty || selectFile.value == null) {
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

      final savingVO = EmergencySavingVO(
          id: id, title: title.text, url: fileURL, body: body.text);
      return _firebaseService.saveEmergencySaving(savingVO).then(
        (value) {
          setLoadingState = LoadingState.complete;

          showDialog(
            context: context,
            builder: (context) =>
                const SuccessWidget(message: "New Emergency Saving Added!"),
          );

          selectFile.value = null;
          title.clear();
          body.clear();

          _emergencySavingController.callEmergencySavings();
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

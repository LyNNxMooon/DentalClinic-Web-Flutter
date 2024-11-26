// ignore_for_file: avoid_print

import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/data/vos/patient_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:dental_clinic/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PatientManagementController extends BaseController {
  RxList<PatientVO> patientList = <PatientVO>[].obs;

  final _firebaseService = FirebaseServices();

  @override
  void onInit() {
    callPatients();
    super.onInit();
  }

  callPatients() async {
    setLoadingState = LoadingState.loading;
    _firebaseService.getPatientListStream().listen(
      (event) {
        if (event == null || event.isEmpty) {
          setLoadingState = LoadingState.error;
        } else {
          patientList.value = event;
          setLoadingState = LoadingState.complete;
        }
      },
    ).onError((error) {
      setLoadingState = LoadingState.error;
    });

    update();
  }

  Future banOrUnbanPatient(
      String id,
      String name,
      bool isBanned,
      String url,
      int age,
      String gender,
      int phone,
      String address,
      String allergicMedicine,
      TextEditingController banReason,
      BuildContext context) async {
    setLoadingState = LoadingState.loading;

    if (isBanned && banReason.text.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please write the reason to ban this user!";
      showDialog(
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
          function: () => Get.back(),
        ),
      );
    } else {
      final patient = PatientVO(
          banReason: banReason.text,
          address: address,
          allergicMedicine: allergicMedicine,
          phone: phone,
          id: id,
          url: url,
          name: name,
          isBanned: isBanned,
          age: age,
          gender: gender);

      _firebaseService.savePatient(patient).then(
        (value) {
          setLoadingState = LoadingState.complete;
          Fluttertoast.showToast(
              msg: "Patient Status Updated!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: kSuccessColor,
              textColor: kFourthColor,
              fontSize: 20);
          banReason.clear();
          Get.back();
          Get.back();
          callPatients();
        },
      ).catchError((error) {
        print(error);
        setLoadingState = LoadingState.error;
        setErrorMessage = error;
        Fluttertoast.showToast(
            msg: getErrorMessage,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: kErrorColor,
            textColor: kPrimaryColor,
            fontSize: 20);
      });
    }

    update();
  }
}

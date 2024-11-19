// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/controller/receptionist_home_controller.dart';
import 'package:dental_clinic/data/vos/doctor_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class DoctorDetailController extends BaseController {
  final _firebaseServices = FirebaseServices();
  final _receptionistHomeController = Get.put(ReceptionistHomeController());

  Future updateDoctor(
    int id,
    String url,
    String name,
    String doctorId,
    String bio,
    String specialist,
    String experience,
    Map<String, List> availability,
  ) async {
    bool hasWorkingHours = availability.values.any((times) => times.isNotEmpty);
    if (name.isEmpty &&
        doctorId.isEmpty &&
        bio.isEmpty &&
        specialist.isEmpty &&
        experience.isEmpty &&
        !hasWorkingHours) {
      setLoadingState = LoadingState.error;
      Fluttertoast.showToast(
          msg: "Fill all the fields!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: kErrorColor,
          textColor: kPrimaryColor,
          fontSize: 20);
    } else if (name.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter doctor name!";
      Fluttertoast.showToast(
          msg: getErrorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: kErrorColor,
          textColor: kPrimaryColor,
          fontSize: 20);
    } else if (doctorId.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter doctor ID!";
      Fluttertoast.showToast(
          msg: getErrorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: kErrorColor,
          textColor: kPrimaryColor,
          fontSize: 20);
    } else if (bio.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter doctor's biography!";
      Fluttertoast.showToast(
          msg: getErrorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: kErrorColor,
          textColor: kPrimaryColor,
          fontSize: 20);
    } else if (specialist.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter doctor's specialist!";
      Fluttertoast.showToast(
          msg: getErrorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: kErrorColor,
          textColor: kPrimaryColor,
          fontSize: 20);
    } else if (experience.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter doctor's experience!";
      Fluttertoast.showToast(
          msg: getErrorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: kErrorColor,
          textColor: kPrimaryColor,
          fontSize: 20);
    } else if (!hasWorkingHours) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please select doctor's working hours!";
      Fluttertoast.showToast(
          msg: getErrorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: kErrorColor,
          textColor: kPrimaryColor,
          fontSize: 20);
    } else {
      setLoadingState = LoadingState.loading;

      final doctor = DoctorVO(
          doctorID: doctorId,
          id: id,
          url: url,
          name: name,
          bio: bio,
          specialist: specialist,
          experience: experience,
          availability: availability);

      return _firebaseServices.saveDoctor(doctor).then(
        (value) {
          setLoadingState = LoadingState.complete;
          Fluttertoast.showToast(
              msg: "Doctor Updated!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: kSuccessColor,
              textColor: kFourthColor,
              fontSize: 20);
          _receptionistHomeController.callDoctors();
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

  Future deleteDoctor(int id) async {
    setLoadingState = LoadingState.loading;
    _firebaseServices.deleteDoctor(id).then(
      (value) {
        setLoadingState = LoadingState.complete;
        Fluttertoast.showToast(
            msg: "Doctor Deleted!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: kSuccessColor,
            textColor: kFourthColor,
            fontSize: 20);
        Get.back();
        Get.back();
        _receptionistHomeController.callDoctors();
      },
    ).catchError((error) {
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

    update();
  }
}

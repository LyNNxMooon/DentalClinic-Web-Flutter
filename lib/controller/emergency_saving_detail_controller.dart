// ignore_for_file: avoid_print

import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/controller/emergency_saving_controller.dart';
import 'package:dental_clinic/data/vos/emergency_saving_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class EmergencySavingDetailController extends BaseController {
  final _firebaseService = FirebaseServices();

  final _emergencySavingController = Get.put(EmergencySavingController());

  Future updateEmergencySaving(
    int id,
    String url,
    String title,
    String body,
  ) async {
    if (title.isEmpty || body.isEmpty) {
      setLoadingState = LoadingState.error;
      Fluttertoast.showToast(
          msg: "Fill all the fields!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: kErrorColor,
          textColor: kPrimaryColor,
          fontSize: 20);
    } else {
      setLoadingState = LoadingState.loading;

      final savingVO =
          EmergencySavingVO(id: id, title: title, url: url, body: body);
      return _firebaseService.saveEmergencySaving(savingVO).then(
        (value) {
          setLoadingState = LoadingState.complete;
          Fluttertoast.showToast(
              msg: "Emergency Saving Updated!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: kSuccessColor,
              textColor: kFourthColor,
              fontSize: 20);
          _emergencySavingController.callEmergencySavings();
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
  }

  Future deleteEmergencySaving(int id) async {
    setLoadingState = LoadingState.loading;
    return _firebaseService.deleteEmergencySaving(id).then(
      (value) {
        setLoadingState = LoadingState.complete;
        Fluttertoast.showToast(
            msg: "Emergency Saving Deleted!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: kSuccessColor,
            textColor: kFourthColor,
            fontSize: 20);
        Get.back();
        Get.back();
        _emergencySavingController.callEmergencySavings();
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
  }
}

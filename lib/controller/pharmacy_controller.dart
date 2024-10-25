// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/data/vos/pharmacy_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:dental_clinic/widgets/error_widget.dart';
import 'package:dental_clinic/widgets/success_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PharmacyController extends BaseController {
  Rxn<Uint8List> selectFile = Rxn<Uint8List>();

  final _firebaseService = FirebaseServices();

  RxList<PharmacyVO> pharmacies = <PharmacyVO>[].obs;

  @override
  void onInit() {
    callPharmacy();
    super.onInit();
  }

  callPharmacy() async {
    setLoadingState = LoadingState.loading;
    _firebaseService.getPharmacyListStream().listen(
      (event) {
        if (event == null || event.isEmpty) {
          setLoadingState = LoadingState.error;
        } else {
          pharmacies.value = event;
          setLoadingState = LoadingState.complete;
        }
      },
    ).onError((error) {
      setLoadingState = LoadingState.error;
    });

    update();
  }

  Future addPharmacy(TextEditingController nameController,
      TextEditingController priceController, BuildContext context) async {
    RegExp letterRegExp = RegExp(r'[a-zA-Z]');
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        letterRegExp.hasMatch(priceController.text) ||
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

      final pharmacyVO = PharmacyVO(
          id: id,
          name: nameController.text,
          price: double.parse(priceController.text),
          url: fileURL);
      return _firebaseService.savePharmacy(pharmacyVO).then(
        (value) {
          setLoadingState = LoadingState.complete;

          showDialog(
            context: context,
            builder: (context) =>
                const SuccessWidget(message: "New pharmacy Added!"),
          );

          selectFile.value = null;
          nameController.clear();
          priceController.clear();
          callPharmacy();
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

    update();
  }

  Future updatePharmacy(int id, String name, String price, String url,
      BuildContext context) async {
    RegExp letterRegExp = RegExp(r'[a-zA-Z]');
    if (name.isEmpty || price.isEmpty || letterRegExp.hasMatch(price)) {
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

      final pharmacyVo = PharmacyVO(
        id: id,
        name: name,
        price: double.parse(price),
        url: url,
      );
      return _firebaseService.savePharmacy(pharmacyVo).then(
        (value) {
          setLoadingState = LoadingState.complete;
          Fluttertoast.showToast(
              msg: "Pharmacy Updated!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: kSuccessColor,
              textColor: kFourthColor,
              fontSize: 20);

          Get.back();
          callPharmacy();
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

    update();
  }

  Future deletePharmacy(int id) async {
    setLoadingState = LoadingState.loading;
    _firebaseService.deletePharmacy(id).then(
      (value) {
        setLoadingState = LoadingState.complete;
        Fluttertoast.showToast(
            msg: "Pharmacy Deleted!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: kSuccessColor,
            textColor: kFourthColor,
            fontSize: 20);
        Get.back();

        callPharmacy();
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

  Future _uploadFileToFirebaseStorage() {
    String path = 'image';
    String contentType = 'image/jpg';

    return FirebaseServices.uploadToFirebaseStorage(
        selectFile.value!, path, contentType);
  }
}

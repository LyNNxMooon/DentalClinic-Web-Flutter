// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/data/vos/payment_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:dental_clinic/widgets/error_widget.dart';
import 'package:dental_clinic/widgets/success_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class PaymentController extends BaseController {
  Rxn<Uint8List> selectFile = Rxn<Uint8List>();

  final _firebaseService = FirebaseServices();

  RxList<PaymentVO> payments = <PaymentVO>[].obs;

  @override
  void onInit() {
    callPayments();
    super.onInit();
  }

  callPayments() async {
    setLoadingState = LoadingState.loading;
    _firebaseService.getPaymentListStream().listen(
      (event) {
        if (event == null || event.isEmpty) {
          setLoadingState = LoadingState.error;
        } else {
          payments.value = event;
          setLoadingState = LoadingState.complete;
        }
      },
    ).onError((error) {
      setLoadingState = LoadingState.error;
    });

    update();
  }

  Future addPayment(
      TextEditingController accountName,
      TextEditingController accountNumber,
      TextEditingController type,
      BuildContext context) async {
    if (accountName.text.isEmpty &&
        accountNumber.text.isEmpty &&
        type.text.isEmpty &&
        selectFile.value == null) {
      setLoadingState = LoadingState.error;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: "Please fill all the payment information!",
          function: () {
            Get.back();
          },
        ),
      );
    } else if (selectFile.value == null) {
      setLoadingState = LoadingState.error;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: "Please upload payment photo!",
          function: () {
            Get.back();
          },
        ),
      );
    } else if (accountName.text.isEmpty) {
      setLoadingState = LoadingState.error;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: "Please enter account name!",
          function: () {
            Get.back();
          },
        ),
      );
    } else if (accountNumber.text.isEmpty) {
      setLoadingState = LoadingState.error;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: "Please enter account number!",
          function: () {
            Get.back();
          },
        ),
      );
    } else if (type.text.isEmpty) {
      setLoadingState = LoadingState.error;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: "Please enter payment type!",
          function: () {
            Get.back();
          },
        ),
      );
    } else {
      setLoadingState = LoadingState.loading;
      int id = DateTime.now().millisecondsSinceEpoch;

      String fileURL = await _uploadFileToFirebaseStorage();

      final paymentVO = PaymentVO(
          id: id,
          accountName: accountName.text,
          accountNumber: accountNumber.text,
          type: type.text,
          url: fileURL);
      return _firebaseService.savePayment(paymentVO).then(
        (value) {
          setLoadingState = LoadingState.complete;

          showDialog(
            context: context,
            builder: (context) =>
                const SuccessWidget(message: "New payment Added!"),
          );

          selectFile.value = null;
          accountName.clear();
          accountNumber.clear();
          type.clear();
          callPayments();
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

  Future updatePayment(int id, String name, String number, String type,
      String url, BuildContext context) async {
    if (name.isEmpty && number.isEmpty && type.isEmpty) {
      setLoadingState = LoadingState.error;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: "Please enter all the payment information!",
          function: () {
            Get.back();
          },
        ),
      );
    } else if (name.isEmpty) {
      setLoadingState = LoadingState.error;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: "Please enter account name!",
          function: () {
            Get.back();
          },
        ),
      );
    } else if (number.isEmpty) {
      setLoadingState = LoadingState.error;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: "Please enter account number!",
          function: () {
            Get.back();
          },
        ),
      );
    } else if (type.isEmpty) {
      setLoadingState = LoadingState.error;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: "Please enter payment type!",
          function: () {
            Get.back();
          },
        ),
      );
    } else {
      setLoadingState = LoadingState.loading;

      final paymentVO = PaymentVO(
          id: id,
          accountName: name,
          accountNumber: number,
          url: url,
          type: type);
      return _firebaseService.savePayment(paymentVO).then(
        (value) {
          setLoadingState = LoadingState.complete;
          Fluttertoast.showToast(
              msg: "Payment Updated!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: kSuccessColor,
              textColor: kFourthColor,
              fontSize: 20);

          Get.back();
          callPayments();
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

  Future deletePayments(int id) async {
    setLoadingState = LoadingState.loading;
    _firebaseService.deletePayment(id).then(
      (value) {
        setLoadingState = LoadingState.complete;
        Fluttertoast.showToast(
            msg: "Payment Deleted!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: kSuccessColor,
            textColor: kFourthColor,
            fontSize: 20);
        Get.back();

        callPayments();
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

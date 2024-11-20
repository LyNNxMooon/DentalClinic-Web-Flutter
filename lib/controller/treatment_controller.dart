// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:typed_data';

import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/appointment_controller.dart';
import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/data/vos/appointment_vo.dart';
import 'package:dental_clinic/data/vos/payment_vo.dart';
import 'package:dental_clinic/data/vos/treatment_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:dental_clinic/widgets/error_widget.dart';
import 'package:dental_clinic/widgets/success_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TreatmentController extends BaseController {
  final _appointmentController = Get.put(AppointmentController());

  RxList<AppointmentVO> todayAppointments = <AppointmentVO>[].obs;

  Rxn<AppointmentVO> selectedAppointment = Rxn<AppointmentVO>();

  RxList<TreatmentVO> treatmentList = <TreatmentVO>[].obs;

  DateTime todayDate = DateTime.now();

  final _firebaseService = FirebaseServices();

  Rxn<PaymentVO> selectedPayment = Rxn<PaymentVO>();

  Rxn<Uint8List> selectFile = Rxn<Uint8List>();

  @override
  void onInit() {
    callTreatments();

    super.onInit();
  }

  getTodayAppointments() {
    todayAppointments.value = [];
    for (AppointmentVO appointment in _appointmentController.appointmentList) {
      if (appointment.date == DateFormat('yMMMMd').format(todayDate)) {
        todayAppointments.add(appointment);
      }
    }
    update();
  }

  callTreatments() async {
    setLoadingState = LoadingState.loading;
    _firebaseService.getTreatmentListStream().listen(
      (event) {
        if (event == null || event.isEmpty) {
          setLoadingState = LoadingState.error;
        } else {
          treatmentList.value = event;
          setLoadingState = LoadingState.complete;
        }
      },
    ).onError((error) {
      setLoadingState = LoadingState.error;
    });
    update();
  }

  Future addTreatment(
      TextEditingController treatmentController,
      TextEditingController dosageController,
      TextEditingController cost,
      TextEditingController discount,
      String time,
      String paymentStatus,
      BuildContext context) async {
    RegExp letterRegExp = RegExp(r'[a-zA-Z]');
    if (selectedAppointment.value == null) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please select one of today's appointments!";
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
    } else if (time.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please select time!";
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
    } else if (treatmentController.text.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter treatment name!";
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
    } else if (dosageController.text.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Pleases enter medical information and dosage!";
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
    } else if (cost.text.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter treatment's cost!";
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
    } else if (letterRegExp.hasMatch(cost.text)) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Treatment cost must be numbers!";
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
    } else if (discount.text.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Please enter discount!";
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
    } else if (letterRegExp.hasMatch(discount.text)) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Discount must be numbers!";
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
    } else if (paymentStatus == "Paid" && selectedPayment.value == null) {
      setLoadingState = LoadingState.error;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: "Select payments!",
          function: () {
            Get.back();
          },
        ),
      );
    } else {
      setLoadingState = LoadingState.loading;
      int id = DateTime.now().millisecondsSinceEpoch;

      double finalCost = double.parse(discount.text) == 0
          ? double.parse(cost.text)
          : double.parse(cost.text) -
              (double.parse(cost.text) * (double.parse(discount.text) / 100));

      String fileURL = "";

      if (selectFile.value != null) {
        fileURL = await _uploadFileToFirebaseStorage();
      } else if (selectedPayment.value?.accountName != "Cash" &&
          paymentStatus == "Paid" &&
          selectFile.value == null) {
        fileURL =
            "https://thumbs.dreamstime.com/b/sad-document-no-data-file-icon-white-334021734.jpg";
      }

      final treatment = TreatmentVO(
          id: id,
          cost: finalCost,
          discount: double.parse(discount.text),
          date: DateFormat('yMMMMd').format(todayDate),
          doctorID: selectedAppointment.value!.doctorId,
          doctorName: selectedAppointment.value!.doctorName,
          patientID: selectedAppointment.value!.patientId,
          patientName: selectedAppointment.value!.patientName,
          dosage: dosageController.text,
          treatment: treatmentController.text,
          slip: fileURL,
          time: time,
          paymentStatus: paymentStatus,
          paymentType: selectedPayment.value?.type ?? "");
      return _firebaseService.saveTreatment(treatment).then(
        (value) {
          setLoadingState = LoadingState.complete;

          showDialog(
            context: context,
            builder: (context) =>
                const SuccessWidget(message: "New Treatment Added!"),
          ).then((value) {
            callTreatments();
            Get.back();
          });

          selectedAppointment.value = null;
          selectedPayment.value = null;
          selectFile.value = null;
          treatmentController.clear();
          dosageController.clear();
          cost.clear();
          discount.clear();
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

  Future updateTreatment(
      int id,
      String patientID,
      String patientName,
      int doctorID,
      String doctorName,
      String date,
      String treatment,
      String dosage,
      double cost,
      double discount,
      String time,
      String paymentStatus,
      String slip,
      String type) async {
    double finalCost = discount == 0 ? cost : cost - (cost * (discount / 100));
    setLoadingState = LoadingState.loading;

    String url = "";

    if (selectFile.value != null) {
      url = await _uploadFileToFirebaseStorage();
    } else {
      url = slip;
    }

    final treatmentVO = TreatmentVO(
        time: time,
        paymentStatus: paymentStatus,
        paymentType: type,
        slip: url,
        cost: finalCost,
        discount: discount,
        id: id,
        doctorID: doctorID,
        doctorName: doctorName,
        patientID: patientID,
        patientName: patientName,
        treatment: treatment,
        dosage: dosage,
        date: date);
    _firebaseService.saveTreatment(treatmentVO).then(
      (value) {
        setLoadingState = LoadingState.complete;

        Get.back();
        Fluttertoast.showToast(
            msg: "Treatment Updated!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: kSuccessColor,
            textColor: kFourthColor,
            fontSize: 20);

        callTreatments();

        selectedPayment.value = null;
        selectFile.value = null;
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

    update();
  }

  Future deleteTreatments(int id) async {
    setLoadingState = LoadingState.loading;
    _firebaseService.deleteTreatment(id).then(
      (value) {
        setLoadingState = LoadingState.complete;
        Fluttertoast.showToast(
            msg: "Treatment Deleted!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: kSuccessColor,
            textColor: kFourthColor,
            fontSize: 20);
        Get.back();

        callTreatments();
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

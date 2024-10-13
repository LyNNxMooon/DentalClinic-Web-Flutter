// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/appointment_controller.dart';
import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/data/vos/appointment_vo.dart';
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

  Future addTreatment(TextEditingController treatmentController,
      TextEditingController dosageController, BuildContext context) async {
    if (treatmentController.text.isEmpty ||
        dosageController.text.isEmpty ||
        selectedAppointment.value == null) {
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

      final treatment = TreatmentVO(
          id: id,
          date: DateFormat('yMMMMd').format(todayDate),
          doctorID: selectedAppointment.value!.doctorId,
          doctorName: selectedAppointment.value!.doctorName,
          patientID: selectedAppointment.value!.patientId,
          patientName: selectedAppointment.value!.patientName,
          dosage: dosageController.text,
          treatment: treatmentController.text);
      return _firebaseService.saveTreatment(treatment).then(
        (value) {
          setLoadingState = LoadingState.complete;

          callTreatments();

          showDialog(
            context: context,
            builder: (context) =>
                const SuccessWidget(message: "New Treatment Added!"),
          ).then(
            (value) => Get.back(),
          );

          selectedAppointment.value = null;
          treatmentController.clear();
          dosageController.clear();
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
  ) async {
    setLoadingState = LoadingState.loading;

    final treatmentVO = TreatmentVO(
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
}

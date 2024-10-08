// ignore_for_file: use_build_context_synchronously

import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/base_controller.dart';

import 'package:dental_clinic/data/vos/appointment_vo.dart';
import 'package:dental_clinic/data/vos/doctor_vo.dart';
import 'package:dental_clinic/data/vos/patient_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:dental_clinic/widgets/error_widget.dart';
import 'package:dental_clinic/widgets/success_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AppointmentController extends BaseController {
  final _firebaseService = FirebaseServices();

  Rxn<PatientVO> patient = Rxn<PatientVO>();
  Rxn<DoctorVO> doctor = Rxn<DoctorVO>();

  RxList<AppointmentVO> appointmentList = <AppointmentVO>[].obs;

  @override
  void onInit() {
    callAppointments();

    super.onInit();
  }

  Future addAppointment(
      String? date, String? time, BuildContext context) async {
    if (date == null ||
        time == null ||
        patient.value == null ||
        doctor.value == null) {
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

      final appointment = AppointmentVO(
          id: id,
          doctorId: doctor.value!.id,
          doctorName: doctor.value!.name,
          patientId: patient.value!.id,
          patientName: patient.value!.name,
          date: date,
          time: time);
      return _firebaseService.saveAppointment(appointment).then(
        (value) {
          setLoadingState = LoadingState.complete;

          showDialog(
            context: context,
            builder: (context) =>
                const SuccessWidget(message: "New Appointment Added!"),
          ).then(
            (value) => Get.back(),
          );

          callAppointments();
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
  }

  callAppointments() async {
    setLoadingState = LoadingState.loading;
    _firebaseService.getAppointmentListStream().listen(
      (event) {
        print(event);
        if (event == null || event.isEmpty) {
          setLoadingState = LoadingState.error;
        } else {
          appointmentList.value = event;
          setLoadingState = LoadingState.complete;
        }
      },
    ).onError((error) {
      setLoadingState = LoadingState.error;
    });
  }

  Future deleteAppointments(int id) async {
    setLoadingState = LoadingState.loading;
    return _firebaseService.deleteAppointment(id).then(
      (value) {
        setLoadingState = LoadingState.complete;
        Fluttertoast.showToast(
            msg: "Appointment Deleted!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: kSuccessColor,
            textColor: kFourthColor,
            fontSize: 20);
        Get.back();

        callAppointments();
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

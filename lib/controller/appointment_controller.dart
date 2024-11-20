// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:async';

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
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AppointmentController extends BaseController {
  final _firebaseService = FirebaseServices();

  Rxn<PatientVO> patient = Rxn<PatientVO>();
  Rxn<DoctorVO> doctor = Rxn<DoctorVO>();

  RxList<AppointmentVO> appointmentList = <AppointmentVO>[].obs;

  RxList<AppointmentVO> alertAppointmentList = <AppointmentVO>[].obs;

  RxList<AppointmentVO> todayAppointmentList = <AppointmentVO>[].obs;

  RxString date = "".obs;

  @override
  void onInit() {
    callAppointments();

    super.onInit();
  }

  Future addAppointment(
      String? date, String? time, BuildContext context) async {
    if (doctor.value == null) {
      setLoadingState = LoadingState.error;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: "Select doctor to make an appointment!",
          function: () {
            Get.back();
          },
        ),
      );
    } else if (patient.value == null) {
      setLoadingState = LoadingState.error;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: "Select patient to make an appointment!",
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
          patientPhone: patient.value!.phone,
          date: date!,
          time: time!);
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
          patient.value = null;
          doctor.value = null;
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

  callAppointments() async {
    String today = DateFormat('yMMMMd').format(DateTime.now());
    todayAppointmentList.clear();
    setLoadingState = LoadingState.loading;
    _firebaseService.getAppointmentListStream().listen(
      (event) {
        if (event == null || event.isEmpty) {
          setLoadingState = LoadingState.error;
        } else {
          appointmentList.value = event;

          for (AppointmentVO appointment in event) {
            if (appointment.date == today) {
              todayAppointmentList.add(appointment);
            }
          }
          setLoadingState = LoadingState.complete;
        }
      },
    ).onError((error) {
      setLoadingState = LoadingState.error;
    });
    update();
  }

  Future deleteAppointments(int id) async {
    setLoadingState = LoadingState.loading;
    _firebaseService.deleteAppointment(id).then(
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

    update();
  }

  alertAppointment(BuildContext context) {
    DateTime now = DateTime.now();

    for (AppointmentVO appointment in appointmentList) {
      DateTime appointmentDateTime = DateFormat('MMMM d, yyyy h:mm a')
          .parse('${appointment.date} ${appointment.time}');

      Duration difference = appointmentDateTime.difference(now);

      if (difference.inMinutes == 15) {
        alertAppointmentList.add(appointment);
      }
    }

    if (alertAppointmentList.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            Center(
                child: TextButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(kSecondaryColor),
                        foregroundColor: WidgetStatePropertyAll(kFourthColor)),
                    onPressed: () {
                      alertAppointmentList.clear();
                      Get.back();
                    },
                    child: const Text("OK")))
          ],
          content: SizedBox(
            width: 350,
            height: 300,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: kErrorColor,
                  ),
                  const Gap(20),
                  Text(
                    "Appointments in 15 minutes : ${alertAppointmentList.length}",
                    style: const TextStyle(
                        color: kSecondaryColor, fontWeight: FontWeight.bold),
                  ),
                  const Gap(20),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: kMessageBubbleColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1), // Shadow color
                                  spreadRadius: 3, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset: const Offset(
                                      0, 3), // Offset of the shadow
                                ),
                              ], //border corner radius
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                  const TextSpan(
                                      text: "Patient : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kSecondaryColor)),
                                  TextSpan(
                                    text:
                                        alertAppointmentList[index].patientName,
                                  ),
                                ])),
                                const Gap(15),
                                RichText(
                                    text: TextSpan(children: [
                                  const TextSpan(
                                      text: "Doctor : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kSecondaryColor)),
                                  TextSpan(
                                    text:
                                        alertAppointmentList[index].doctorName,
                                  ),
                                ])),
                                const Gap(15),
                                RichText(
                                    text: TextSpan(children: [
                                  const TextSpan(
                                      text: "Patient Contact : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kSecondaryColor)),
                                  TextSpan(
                                    text: alertAppointmentList[index]
                                        .patientPhone
                                        .toString(),
                                  ),
                                ])),
                              ],
                            ),
                          ),
                      separatorBuilder: (context, index) => const Gap(15),
                      itemCount: alertAppointmentList.length)
                ],
              ),
            ),
          ),
        ),
      );

      Timer.periodic(const Duration(seconds: 49), (timer) {
        alertAppointmentList.clear();
      });
    }
    update();
  }
}

/*
showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actions: [
              Center(
                  child: TextButton(
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(kSecondaryColor),
                          foregroundColor:
                              WidgetStatePropertyAll(kFourthColor)),
                      onPressed: () => Get.back(),
                      child: const Text("OK")))
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: kErrorColor,
                ),
                const Gap(20),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: appointment.patientName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const TextSpan(
                      text: " has an appointment with ",
                      style: TextStyle(fontSize: 16)),
                  TextSpan(
                      text: "Doctor ${appointment.doctorName}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const TextSpan(
                      text: " in 15 minutes", style: TextStyle(fontSize: 16)),
                ])),
                const Gap(20),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: "Date : ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: kSecondaryColor)),
                  TextSpan(
                      text: appointment.date,
                      style: const TextStyle(fontSize: 16)),
                ])),
                const Gap(20),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: "Time : ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: kSecondaryColor)),
                  TextSpan(
                      text: appointment.time,
                      style: const TextStyle(fontSize: 16)),
                ])),
                const Gap(20),
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: "Patient Contact : ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: kSecondaryColor)),
                  TextSpan(
                      text: appointment.patientPhone.toString(),
                      style: const TextStyle(fontSize: 16)),
                ])),
              ],
            ),
          ),
        );
*/

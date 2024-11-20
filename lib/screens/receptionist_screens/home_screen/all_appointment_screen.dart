import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/controller/appointment_controller.dart';
import 'package:dental_clinic/utils/hover_extensions.dart';
import 'package:dental_clinic/widgets/load_fail_widget.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/no_connection_desktop_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/vos/appointment_vo.dart';

List<AppointmentVO> filteredAppointments = <AppointmentVO>[];

final _appointmentController = Get.put(AppointmentController());

class AllAppointmentScreen extends StatefulWidget {
  const AllAppointmentScreen({super.key});

  @override
  State<AllAppointmentScreen> createState() => _AllAppointmentScreenState();
}

class _AllAppointmentScreenState extends State<AllAppointmentScreen> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  String connection = "online";

  @override
  void initState() {
    super.initState();
    initConnectivity();
    filteredAppointments = _appointmentController.appointmentList;
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;

    result = await _connectivity.checkConnectivity();
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
      if (_connectionStatus[0] == ConnectivityResult.none) {
        connection = "offline";
      } else {
        connection = "online";
      }
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _appointmentController.date.value =
            DateFormat('yMMMMd').format(pickedDate);
        filterAppointments();
      });
    }
  }

  void filterAppointments() {
    List<AppointmentVO> appointmentsByDate = <AppointmentVO>[];
    for (AppointmentVO appointment in _appointmentController.appointmentList) {
      if (appointment.date == _appointmentController.date.value) {
        appointmentsByDate.add(appointment);
      }
    }
    setState(() {
      filteredAppointments = appointmentsByDate;
    });
  }

  void clearFilteredAppointments() {
    setState(() {
      _appointmentController.date.value = "";
      filteredAppointments = _appointmentController.appointmentList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  icon: const Icon(Icons.date_range)),
              const Gap(20)
            ],
            centerTitle: true,
            title: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _appointmentController.date.value.isEmpty
                        ? "All Appointments"
                        : _appointmentController.date.value,
                    style: desktopTitleStyle,
                  ),
                  _appointmentController.date.value.isEmpty
                      ? const SizedBox()
                      : IconButton(
                          onPressed: () => clearFilteredAppointments(),
                          icon: const Icon(Icons.clear))
                ],
              ),
            )),
        body: connection == "online"
            ? Padding(
                padding: const EdgeInsets.all(30),
                child: filteredAppointments.isEmpty
                    ? const Center(
                        child: Text(
                          "No Appointments on this date!",
                          style: mobileTitleStyle,
                        ),
                      )
                    : Obx(
                        () => LoadingStateWidget(
                            paddingTop:
                                MediaQuery.of(context).size.height * 0.1,
                            paddingBottom:
                                MediaQuery.of(context).size.height * 0.1,
                            loadingState:
                                _appointmentController.getLoadingState,
                            loadingSuccessWidget: AppointmentList(
                              appointments: filteredAppointments,
                            ),
                            loadingInitWidget: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0.1,
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.1),
                              child: LoadFailWidget(
                                function: () {
                                  _appointmentController.callAppointments();
                                },
                              ),
                            )),
                      ),
              )
            : const NoConnectionDesktopWidget(),
      ),
    );
  }
}

class AppointmentList extends StatefulWidget {
  const AppointmentList({super.key, required this.appointments});

  final List<AppointmentVO> appointments;

  @override
  State<AppointmentList> createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5,
        mainAxisExtent: 265,
      ),
      itemCount: widget.appointments.length,
      itemBuilder: (context, index) => AppointmentCard(
        appointment: widget.appointments[index],
      ).showCursorOnHover.moveUpOnHover,
    );
  }
}

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({super.key, required this.appointment});

  final AppointmentVO appointment;

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
        borderRadius: BorderRadius.circular(8), //border corner radius
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.date_range),
              const SizedBox(
                height: 15,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: widget.appointment.date,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ])),
              const SizedBox(
                height: 15,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: widget.appointment.time,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ])),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: "Doctor : ${widget.appointment.doctorName}",
                        ),
                      ])),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: "Patient : ${widget.appointment.patientName}",
                        ),
                      ])),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              DeleteBtn(function: () {
                _appointmentController
                    .deleteAppointments(widget.appointment.id);
                setState(() {
                  _appointmentController.date.value = "";
                  filteredAppointments = _appointmentController.appointmentList;
                });
              })
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteBtn extends StatelessWidget {
  const DeleteBtn({super.key, required this.function});

  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(kBtnGrayColor)),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(kErrorColor)),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      onPressed: function,
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(kSecondaryColor)),
                      child: const Text(
                        "OK",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ],
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: kErrorColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Are you sure to cancel this appointment?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kErrorColor),
                  ),
                ],
              )),
        );
      },
      child: const Text(
        "Cancel",
        style: TextStyle(color: kErrorColor),
      ),
    );
  }
}

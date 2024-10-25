// ignore_for_file: deprecated_member_use, avoid_function_literals_in_foreach_calls, unnecessary_string_interpolations

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/controller/appointment_controller.dart';
import 'package:dental_clinic/controller/patient_management_controller.dart';
import 'package:dental_clinic/controller/receptionist_home_controller.dart';
import 'package:dental_clinic/data/vos/doctor_vo.dart';
import 'package:dental_clinic/data/vos/patient_vo.dart';
import 'package:dental_clinic/widgets/error_widget.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/no_connection_desktop_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final _receptionistHomeController = Get.put(ReceptionistHomeController());
final _appointmentController = Get.put(AppointmentController());
final _patientManagementController = Get.put(PatientManagementController());

bool isSearchDoctor = false;

class AddAppointmentDesktopScreen extends StatefulWidget {
  const AddAppointmentDesktopScreen({super.key});

  @override
  State<AddAppointmentDesktopScreen> createState() =>
      _AddAppointmentDesktopScreenState();
}

class _AddAppointmentDesktopScreenState
    extends State<AddAppointmentDesktopScreen> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  String connection = "online";

  @override
  void initState() {
    super.initState();
    initConnectivity();

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

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  String getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  String formatTime(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  String convertTimeFormat(String time) {
    final DateFormat dateFormat12Hour =
        DateFormat("h:mm a"); // Input format (e.g., "6:00 PM")
    final DateFormat dateFormat24Hour =
        DateFormat("HH:mm"); // Output format (e.g., "18:00")
    return dateFormat24Hour.format(dateFormat12Hour.parse(time));
  }

  List<DoctorVO> availableDoctorList = [];

  bool _isTimeInSlot(String selectedTime, String slot) {
    List<String> times = slot.split("-");

    String timeSelected = selectedTime;
    String startTime = convertTimeFormat(times[0].trim());
    String endTime = convertTimeFormat(times[1].trim());

    return checkTimeBetween(timeSelected, startTime, endTime);
  }

  bool checkTimeBetween(String timeSelected, String startTime, String endTime) {
    // Parse the time strings into DateTime objects
    DateTime selectedTime = DateTime.parse("1970-01-01 $timeSelected");
    DateTime start = DateTime.parse("1970-01-01 $startTime");
    DateTime end = DateTime.parse("1970-01-01 $endTime");

    print("Triggered");
    // Check if the selected time is between start and end time
    return selectedTime.isAfter(start) && selectedTime.isBefore(end);
  }

  showDoctors() {
    availableDoctorList.clear();
    _receptionistHomeController.doctorsList.forEach((doctorData) {
      if (doctorData.availability != null &&
          doctorData.availability[getDayOfWeek(selectedDate!)] != null) {
        List<String> timeSlots = List<String>.from(
            doctorData.availability[getDayOfWeek(selectedDate!)]);

        // Check if the selected time falls within any of the available time slots
        for (String slot in timeSlots) {
          if (_isTimeInSlot(formatTime(selectedTime!), slot) &&
              !availableDoctorList.contains(doctorData)) {
            availableDoctorList.add(doctorData);
          } else {}
        }
      }
    });
  }

  List<PatientVO> searchPatientList = [];

  searchPatients(String name) {
    for (PatientVO patient in _patientManagementController.patientList) {
      if ((patient.name.toLowerCase().contains(name.toLowerCase()))) {
        searchPatientList.add(patient);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: connection == "online"
          ? Padding(
              padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.arrow_back)),
                        const Text(
                          "Add Appointment",
                          style: desktopTitleStyle,
                        ),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              selectedDate == null
                                  ? 'Select Appointment Date'
                                  : DateFormat('yMMMMd').format(selectedDate!),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              selectedTime == null
                                  ? ', Select Time'
                                  : ", ${selectedTime!.format(context)}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  _selectDate(context);
                                },
                                icon: const Icon(Icons.date_range)),
                            const SizedBox(
                              width: 10,
                            ),
                            IconButton(
                                onPressed: () {
                                  _selectTime(context);
                                },
                                icon: const Icon(Icons.timelapse)),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Obx(
                          () => Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                              color: kBtnGrayColor,
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
                            child: Center(
                              child: Text(_appointmentController.doctor.value ==
                                      null
                                  ? "Select Doctor"
                                  : "Doctor: ${_appointmentController.doctor.value!.name}"),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Obx(
                          () => Container(
                            width: 200,
                            height: 40,
                            decoration: BoxDecoration(
                              color: kBtnGrayColor,
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
                            child: Center(
                              child: Text(_appointmentController
                                          .patient.value ==
                                      null
                                  ? "Select Patient"
                                  : "Patient: ${_appointmentController.patient.value!.name}"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    const Center(
                      child: Text(
                        "Available Doctors",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kSecondaryColor),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: kBtnGrayColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.1), // Shadow color
                            spreadRadius: 3, // Spread radius
                            blurRadius: 5, // Blur radius
                            offset: const Offset(0, 3), // Offset of the shadow
                          ),
                        ], //border corner radius
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("See Doctors"),
                          GestureDetector(
                              onTap: () {
                                showDoctors();
                                setState(() {
                                  isSearchDoctor = !isSearchDoctor;
                                });
                              },
                              child: const Icon(Icons.search)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    isSearchDoctor && availableDoctorList.isEmpty
                        ? const Center(
                            child: Text(
                              "No doctors available!",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        : !isSearchDoctor
                            ? const SizedBox()
                            : DoctorList(
                                availableDoctorList: availableDoctorList),
                    const SizedBox(
                      height: 50,
                    ),
                    const Center(
                      child: Text(
                        "Available Patients",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kSecondaryColor),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      decoration: BoxDecoration(
                        color: kBtnGrayColor,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.1), // Shadow color
                            spreadRadius: 3, // Spread radius
                            blurRadius: 5, // Blur radius
                            offset: const Offset(0, 3), // Offset of the shadow
                          ),
                        ], //border corner radius
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 400,
                            child: TextField(
                              decoration: const InputDecoration(
                                  hintText: "Search Patients",
                                  hintStyle: TextStyle(fontSize: 14),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none)),
                              onChanged: (value) {
                                searchPatientList.clear();
                                setState(() {
                                  searchPatients(value);
                                });
                              },
                            ),
                          ),
                          GestureDetector(
                              onTap: () {}, child: const Icon(Icons.search))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PatientList(availablePatientList: searchPatientList),
                    const SizedBox(
                      height: 30,
                    ),
                    Obx(
                      () => LoadingStateWidget(
                        loadingState: _appointmentController.getLoadingState,
                        loadingSuccessWidget: AddBtn(function: () {
                          if (selectedDate == null || selectedTime == null) {
                            showDialog(
                              context: context,
                              builder: (context) => CustomErrorWidget(
                                  errorMessage: "Pick date and time",
                                  function: () {
                                    Get.back();
                                  }),
                            );
                          } else {
                            _appointmentController.addAppointment(
                                DateFormat('yMMMMd').format(selectedDate!),
                                selectedTime!.format(context),
                                context);
                          }
                        }),
                        loadingInitWidget: AddBtn(function: () {
                          if (selectedDate == null || selectedTime == null) {
                            showDialog(
                              context: context,
                              builder: (context) => CustomErrorWidget(
                                  errorMessage: "Pick date and time",
                                  function: () {
                                    Get.back();
                                  }),
                            );
                          } else {
                            _appointmentController.addAppointment(
                                DateFormat('yMMMMd').format(selectedDate!),
                                selectedTime!.format(context),
                                context);
                          }
                        }),
                        paddingTop: 0,
                        paddingBottom: 0,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            )
          : const NoConnectionDesktopWidget(),
    );
  }
}

class AddBtn extends StatelessWidget {
  const AddBtn({super.key, required this.function});

  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: kSecondaryColor),
          child: const Center(
            child: Text(
              "Add",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}

class DoctorList extends StatefulWidget {
  const DoctorList({super.key, required this.availableDoctorList});

  final List<DoctorVO> availableDoctorList;

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                _appointmentController.doctor.value =
                    widget.availableDoctorList[index];
              },
              child: Container(
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: kBtnGrayColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color
                      spreadRadius: 3, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset: const Offset(0, 3), // Offset of the shadow
                    ),
                  ], //border corner radius
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 25,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 0.3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          widget.availableDoctorList[index].url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(widget.availableDoctorList[index].name)
                  ],
                ),
              ),
            ),
        separatorBuilder: (context, index) => const SizedBox(
              height: 20,
            ),
        itemCount: widget.availableDoctorList.length);
  }
}

class PatientList extends StatelessWidget {
  const PatientList({super.key, required this.availablePatientList});

  final List<PatientVO> availablePatientList;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                _appointmentController.patient.value =
                    availablePatientList[index];
              },
              child: Container(
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: kBtnGrayColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color
                      spreadRadius: 3, // Spread radius
                      blurRadius: 5, // Blur radius
                      offset: const Offset(0, 3), // Offset of the shadow
                    ),
                  ], //border corner radius
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 25,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 0.3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          availablePatientList[index].url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(availablePatientList[index].name)
                  ],
                ),
              ),
            ),
        separatorBuilder: (context, index) => const SizedBox(
              height: 20,
            ),
        itemCount: availablePatientList.length);
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/controller/doctor_detail_controller.dart';
import 'package:dental_clinic/data/vos/doctor_vo.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/no_connection_desktop_widget.dart';
import 'package:dental_clinic/widgets/textfield.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _doctorDetailController = Get.put(DoctorDetailController());

Map<String, List> availability = {
  "Monday": [],
  "Tuesday": [],
  "Wednesday": [],
  "Thursday": [],
  "Friday": [],
  "Saturday": [],
  "Sunday": [],
};

// Track which days are selected
Map<String, bool> selectedDays = {
  "Monday": false,
  "Tuesday": false,
  "Wednesday": false,
  "Thursday": false,
  "Friday": false,
  "Saturday": false,
  "Sunday": false,
};

late TextEditingController _nameController;

late TextEditingController _bioController;

late TextEditingController _specialistController;

late TextEditingController _experienceController;

class DoctorDetailDesktopScreen extends StatefulWidget {
  const DoctorDetailDesktopScreen(
      {super.key, required this.doctor, required this.initialAvailability});

  final DoctorVO doctor;
  final Map<dynamic, dynamic> initialAvailability;

  @override
  State<DoctorDetailDesktopScreen> createState() =>
      _DoctorDetailDesktopScreenState();
}

class _DoctorDetailDesktopScreenState extends State<DoctorDetailDesktopScreen> {
  @override
  void initState() {
    _nameController = TextEditingController(text: widget.doctor.name);
    _bioController = TextEditingController(text: widget.doctor.bio);
    _specialistController =
        TextEditingController(text: widget.doctor.specialist);
    _experienceController =
        TextEditingController(text: widget.doctor.experience);
    populateInitialData();

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  String connection = "online";

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

  void populateInitialData() {
    // Iterate through the initialAvailability map to update the selectedDays and availability maps
    widget.initialAvailability.forEach((day, times) {
      if (selectedDays.containsKey(day)) {
        selectedDays[day] = true; // Set the day as selected
        availability[day] =
            List<String>.from(times); // Populate the time slots for that day
      }
    });
  }

  Future<void> _selectTime(BuildContext context, String day) async {
    final TimeOfDay? pickedStartTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedStartTime != null) {
      TimeOfDay? pickedEndTime = await showTimePicker(
        context: context,
        initialTime: pickedStartTime,
      );

      if (pickedEndTime != null) {
        setState(() {
          // Store the time slot as a string in the format "HH:mm-HH:mm"
          availability[day]?.add(
              "${pickedStartTime.format(context)} - ${pickedEndTime.format(context)}");
        });
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back)),
                      Obx(
                        () => LoadingStateWidget(
                            loadingState:
                                _doctorDetailController.getLoadingState,
                            loadingSuccessWidget: DeleteBtn(
                              function: () {
                                _doctorDetailController
                                    .deleteDoctor(widget.doctor.id);
                              },
                            ),
                            loadingInitWidget: DeleteBtn(
                              function: () {
                                _doctorDetailController
                                    .deleteDoctor(widget.doctor.id);
                              },
                            ),
                            paddingTop: 0),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    textAlign: TextAlign.start,
                    "Doctor Details",
                    style: desktopTitleStyle,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(105),
                        border: Border.all(width: 0.3),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(105),
                          child: Image.network(
                            widget.doctor.url,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: CustomTextField(
                        hintText: "Enter doctor Name",
                        label: "Name",
                        controller: _nameController,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: CustomTextField(
                        hintText: "Enter doctor Bio",
                        label: "Bio",
                        controller: _bioController,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: CustomTextField(
                        hintText: "Enter doctor Specialist",
                        label: "Specialist",
                        controller: _specialistController,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: 400,
                      child: CustomTextField(
                        hintText: "Enter doctor experience",
                        label: "Experience",
                        controller: _experienceController,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: SizedBox(
                      width: 400,
                      height: 500,
                      child: ListView(
                        shrinkWrap: true,
                        children: selectedDays.keys.map((String day) {
                          return CheckboxListTile(
                            title: Text(day),
                            value: selectedDays[day],
                            onChanged: (bool? value) {
                              setState(() {
                                selectedDays[day] = value ?? false;
                                if (!value!) {
                                  availability[day] =
                                      []; // Clear time slots if unchecked
                                }
                              });
                            },
                            secondary: IconButton(
                              icon: const Icon(Icons.access_time),
                              onPressed: selectedDays[day]!
                                  ? () => _selectTime(context, day)
                                  : null, // Only allow time picking if the day is selected
                            ),
                            subtitle: Text(availability[day]!.isNotEmpty
                                ? "Selected times: ${availability[day]?.join(', ')}"
                                : "No times selected"),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Obx(
                    () => LoadingStateWidget(
                        loadingState: _doctorDetailController.getLoadingState,
                        loadingSuccessWidget: UpdateBtn(
                            id: widget.doctor.id, url: widget.doctor.url),
                        loadingInitWidget: UpdateBtn(
                            id: widget.doctor.id, url: widget.doctor.url),
                        paddingTop: 0),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              )),
            )
          : const NoConnectionDesktopWidget(),
    );
  }
}

class DeleteBtn extends StatelessWidget {
  const DeleteBtn({super.key, required this.function});

  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
                            backgroundColor:
                                WidgetStatePropertyAll(kErrorColor)),
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
                      "Are you sure to delete?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kErrorColor),
                    ),
                  ],
                )),
          );
        },
        icon: const Icon(
          Icons.delete,
          color: kErrorColor,
          size: 40,
        ));
  }
}

class UpdateBtn extends StatelessWidget {
  const UpdateBtn({super.key, required this.id, required this.url});

  final int id;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _doctorDetailController.updateDoctor(
              id,
              url,
              _nameController.text,
              _bioController.text,
              _specialistController.text,
              _experienceController.text,
              availability);
        },
        child: Container(
          width: 400,
          height: 50,
          decoration: BoxDecoration(
              color: kSecondaryColor, borderRadius: BorderRadius.circular(10)),
          child: const Center(
            child: Text(
              "Update",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

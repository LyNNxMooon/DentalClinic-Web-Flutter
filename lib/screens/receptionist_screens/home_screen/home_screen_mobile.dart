// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/add_doctor_controller.dart';
import 'package:dental_clinic/controller/receptionist_home_controller.dart';
import 'package:dental_clinic/data/vos/doctor_vo.dart';
import 'package:dental_clinic/screens/receptionist_screens/doctor_detail_screen/doctor_detail_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_screens/emergency_saving_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/patient_management_screens/patient_management_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/profile_screens/profile_screen.dart';
import 'package:dental_clinic/utils/file_picker_utils.dart';
import 'package:dental_clinic/widgets/load_fail_widget.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';

import 'package:dental_clinic/widgets/navigation_bar_mobile.dart';
import 'package:dental_clinic/widgets/no_connection_mobile_widget.dart';
import 'package:dental_clinic/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _filePicker = FilePickerUtils();
final _addDoctorController = Get.put(AddDoctorController());
final _receptionistHomeController = Get.put(ReceptionistHomeController());

// Keep track of selected days and time slots
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

class MobileHomeScreen extends StatefulWidget {
  const MobileHomeScreen({super.key});

  @override
  State<MobileHomeScreen> createState() => _MobileHomeScreenState();
}

class _MobileHomeScreenState extends State<MobileHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _doctorNameController = TextEditingController();
  final _doctorSpecialistController = TextEditingController();
  final _doctorExperienceController = TextEditingController();

  final _doctorBiosController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const Drawer(
          backgroundColor: kPrimaryColor,
          child: CustomNavigationDrawer(
            title1: "Patients",
            title2: "Emergency",
            title3: "Profile",
            icon1: Icons.people_alt_outlined,
            icon2: Icons.emergency_outlined,
            icon3: Icons.person,
            widget1: PatientManagementScreen(),
            widget2: EmergencySavingScreen(),
            widget3: ReceptionistProfileScreen(),
          )),
      body: connection == "online"
          ? Padding(
              padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MobileNavigationBar(
                      scaffoldKey: _scaffoldKey,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          textAlign: TextAlign.start,
                          "Available Doctors",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AddDoctorDialog(
                                function: () async {
                                  if (connection == "online") {
                                    _addDoctorController.addDoctor(
                                        _doctorNameController,
                                        _doctorBiosController,
                                        _doctorSpecialistController,
                                        _doctorExperienceController,
                                        availability,
                                        context);
                                  } else {
                                    Get.back();
                                  }
                                },
                                nameController: _doctorNameController,
                                bioController: _doctorBiosController,
                                specController: _doctorSpecialistController,
                                expController: _doctorExperienceController,
                              ),
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: BorderRadius.circular(6)),
                            child: const Center(
                              child: Icon(Icons.add),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Obx(
                      () => LoadingStateWidget(
                          paddingTop: 50,
                          loadingState:
                              _receptionistHomeController.getLoadingState,
                          loadingSuccessWidget: DoctorList(
                            doctors: _receptionistHomeController.doctorsList,
                          ),
                          loadingInitWidget: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.22),
                            child: LoadFailWidget(
                              function: () {
                                _receptionistHomeController.callDoctors();
                              },
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          textAlign: TextAlign.start,
                          "Manage Appointments",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AddDoctorDialog(
                                function: () async {
                                  if (connection == "online") {
                                    _addDoctorController.addDoctor(
                                        _doctorNameController,
                                        _doctorBiosController,
                                        _doctorSpecialistController,
                                        _doctorExperienceController,
                                        availability,
                                        context);
                                  } else {
                                    Get.back();
                                  }
                                },
                                nameController: _doctorNameController,
                                bioController: _doctorBiosController,
                                specController: _doctorSpecialistController,
                                expController: _doctorExperienceController,
                              ),
                            );
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: kSecondaryColor,
                                borderRadius: BorderRadius.circular(6)),
                            child: const Center(
                              child: Icon(Icons.add),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          : const NoConnectionMobileWidget(),
    );
  }
}

class DoctorList extends StatelessWidget {
  const DoctorList({super.key, required this.doctors});

  final List<DoctorVO> doctors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 0.0,
          mainAxisExtent: 220,
        ),
        itemCount: _receptionistHomeController.doctorsList.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            Get.to(() => DoctorDetailScreen(doctor: doctors[index]));
          },
          child: DoctorCard(
            doctor: doctors[index],
          ),
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.doctor});

  final DoctorVO doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
        borderRadius: BorderRadius.circular(8), //border corner radius
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  border: Border.all(width: 0.3)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(45),
                child: Image.network(
                  doctor.url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          RichText(
              text: TextSpan(children: [
            const TextSpan(text: "Name : ", style: TextStyle(fontSize: 14)),
            TextSpan(text: doctor.name, style: const TextStyle(fontSize: 14)),
          ])),
          const SizedBox(
            height: 5,
          ),
          RichText(
              text: TextSpan(children: [
            const TextSpan(
                text: "Specialist : ",
                style: TextStyle(fontSize: 12, color: kThirdColor)),
            TextSpan(
                text: doctor.specialist,
                style: const TextStyle(fontSize: 12, color: kThirdColor)),
          ])),
          const SizedBox(
            height: 5,
          ),
          RichText(
              text: TextSpan(children: [
            const TextSpan(
                text: "Experience : ",
                style: TextStyle(fontSize: 12, color: kThirdColor)),
            TextSpan(
                text: doctor.experience,
                style: const TextStyle(fontSize: 12, color: kThirdColor)),
          ])),
        ],
      ),
    );
  }
}

class AddDoctorDialog extends StatefulWidget {
  const AddDoctorDialog({
    super.key,
    required this.function,
    required this.nameController,
    required this.bioController,
    required this.specController,
    required this.expController,
  });

  final VoidCallback function;
  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController specController;
  final TextEditingController expController;

  @override
  State<AddDoctorDialog> createState() => _AddDoctorDialogState();
}

class _AddDoctorDialogState extends State<AddDoctorDialog> {
  // Method to pick time using Flutter's time picker
  Future<void> _selectTime(BuildContext context, String day) async {
    TimeOfDay? pickedStartTime = await showTimePicker(
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
    return AlertDialog(
      actions: [
        Obx(
          () => LoadingStateWidget(
              paddingTop: 0,
              loadingState: _addDoctorController.getLoadingState,
              loadingSuccessWidget: Center(
                child: TextButton(
                  onPressed: widget.function,
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(kSecondaryColor)),
                  child: const Text(
                    "Add",
                    style: TextStyle(color: kFourthColor),
                  ),
                ),
              ),
              loadingInitWidget: Center(
                child: TextButton(
                  onPressed: widget.function,
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(kSecondaryColor)),
                  child: const Text(
                    "Add",
                    style: TextStyle(color: kFourthColor),
                  ),
                ),
              )),
        )
      ],
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "New Doctor",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => Center(
                child: Container(
                    width: 150,
                    height: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: kSecondaryColor)),
                    child: _addDoctorController.selectFile.value == null
                        ? GestureDetector(
                            onTap: () async {
                              _addDoctorController.selectFile.value =
                                  await _filePicker.getImage();
                            },
                            child: const Center(
                              child: Icon(
                                Icons.add_a_photo_outlined,
                                size: 30,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              _addDoctorController.selectFile.value =
                                  await _filePicker.getImage();
                            },
                            child: Container(
                              width: 150,
                              height: 120,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.memory(
                                  _addDoctorController.selectFile.value!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: "Enter doctor name",
              label: "Name",
              controller: widget.nameController,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              hintText: "Enter doctor biography",
              label: "Biography",
              controller: widget.bioController,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              hintText: "Enter doctor specialist",
              label: "Specialist",
              controller: widget.specController,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              hintText: "Enter doctor experience",
              label: "Experience",
              controller: widget.expController,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
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
          ],
        ),
      ),
    );
  }
}

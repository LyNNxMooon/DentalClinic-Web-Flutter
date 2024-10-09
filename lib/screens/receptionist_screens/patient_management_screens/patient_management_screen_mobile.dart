// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/add_patient_controller.dart';
import 'package:dental_clinic/controller/patient_management_controller.dart';
import 'package:dental_clinic/data/vos/patient_vo.dart';
import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_screens/emergency_saving_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen.dart';
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
final _addPatientController = Get.put(AddPatientController());
final _patientManagementController = Get.put(PatientManagementController());
String? _selectedGender;

class MobilePatientManagementScreen extends StatefulWidget {
  const MobilePatientManagementScreen({super.key});

  @override
  State<MobilePatientManagementScreen> createState() =>
      _MobilePatientManagementScreenState();
}

class _MobilePatientManagementScreenState
    extends State<MobilePatientManagementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  String connection = "online";

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

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
            title1: "Home",
            title2: "Emergency",
            title3: "Profile",
            icon1: Icons.home,
            icon2: Icons.emergency_outlined,
            icon3: Icons.person,
            widget1: HomeScreen(),
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
                          "Manage Patients",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AddPatientDialog(
                                function: () async {
                                  if (connection == "online") {
                                    _addPatientController.registerPatients(
                                        _emailController,
                                        _passwordController,
                                        _nameController,
                                        _ageController,
                                        _selectedGender ?? '',
                                        context);
                                  } else {
                                    Get.back();
                                  }
                                },
                                emailController: _emailController,
                                passwordController: _passwordController,
                                ageController: _ageController,
                                nameController: _nameController,
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
                          paddingTop: 100,
                          loadingState:
                              _patientManagementController.getLoadingState,
                          loadingSuccessWidget: PatientList(
                            patients: _patientManagementController.patientList,
                          ),
                          loadingInitWidget: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.22),
                            child: LoadFailWidget(
                              function: () {
                                _patientManagementController.callPatients();
                              },
                            ),
                          )),
                    )
                  ],
                ),
              ),
            )
          : const NoConnectionMobileWidget(),
    );
  }
}

class UnbanBtn extends StatelessWidget {
  const UnbanBtn({super.key, required this.function});

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
                      "Are you sure to un ban?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kErrorColor),
                    ),
                  ],
                )),
          );
        },
        icon: const Icon(
          Icons.restore,
          color: kThirdColor,
        ));
  }
}

class BanBtn extends StatelessWidget {
  const BanBtn({super.key, required this.function});

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
                      "Are you sure to Ban?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kErrorColor),
                    ),
                  ],
                )),
          );
        },
        icon: const Icon(
          Icons.no_accounts,
          color: kErrorColor,
        ));
  }
}

class PatientList extends StatelessWidget {
  const PatientList({super.key, required this.patients});

  final List<PatientVO> patients;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) => PatientTile(patient: patients[index]),
        separatorBuilder: (context, index) => const SizedBox(
              height: 20,
            ),
        itemCount: patients.length);
  }
}

class PatientTile extends StatefulWidget {
  const PatientTile({super.key, required this.patient});

  final PatientVO patient;

  @override
  State<PatientTile> createState() => _PatientTileState();
}

class _PatientTileState extends State<PatientTile> {
  double tileHeight = 50;
  bool isDrop = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      height: tileHeight,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              widget.patient.isBanned
                  ? Obx(
                      () => LoadingStateWidget(
                          loadingState:
                              _patientManagementController.getLoadingState,
                          loadingSuccessWidget: UnbanBtn(
                            function: () {
                              _patientManagementController.banOrUnbanPatient(
                                  widget.patient.id,
                                  widget.patient.name,
                                  false,
                                  widget.patient.url,
                                  widget.patient.age,
                                  widget.patient.gender);
                            },
                          ),
                          loadingInitWidget: UnbanBtn(
                            function: () {
                              _patientManagementController.banOrUnbanPatient(
                                  widget.patient.id,
                                  widget.patient.name,
                                  false,
                                  widget.patient.url,
                                  widget.patient.age,
                                  widget.patient.gender);
                            },
                          ),
                          paddingTop: 0),
                    )
                  : Obx(
                      () => LoadingStateWidget(
                          loadingState:
                              _patientManagementController.getLoadingState,
                          loadingSuccessWidget: BanBtn(
                            function: () {
                              _patientManagementController.banOrUnbanPatient(
                                  widget.patient.id,
                                  widget.patient.name,
                                  true,
                                  widget.patient.url,
                                  widget.patient.age,
                                  widget.patient.gender);
                            },
                          ),
                          loadingInitWidget: BanBtn(
                            function: () {
                              _patientManagementController.banOrUnbanPatient(
                                  widget.patient.id,
                                  widget.patient.name,
                                  true,
                                  widget.patient.url,
                                  widget.patient.age,
                                  widget.patient.gender);
                            },
                          ),
                          paddingTop: 0),
                    ),
              const SizedBox(
                width: 30,
              ),
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 0.3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.patient.url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              isDrop
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.patient.name),
                        const SizedBox(
                          height: 15,
                        ),
                        Text("Age : ${widget.patient.age}"),
                        const SizedBox(
                          height: 15,
                        ),
                        Text("Gender : ${widget.patient.gender}"),
                      ],
                    )
                  : Text(widget.patient.name)
            ],
          ),
          GestureDetector(
              onTap: () {
                setState(() {
                  isDrop = !isDrop;
                  tileHeight = isDrop ? 110 : 50;
                });
              },
              child: Icon(isDrop ? Icons.arrow_drop_up : Icons.arrow_drop_down))
        ],
      ),
    );
  }
}

class AddPatientDialog extends StatefulWidget {
  const AddPatientDialog({
    super.key,
    required this.function,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.ageController,
  });

  final VoidCallback function;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController ageController;

  @override
  State<AddPatientDialog> createState() => _AddPatientDialogState();
}

class _AddPatientDialogState extends State<AddPatientDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Obx(
          () => LoadingStateWidget(
              paddingTop: 0,
              loadingState: _addPatientController.getLoadingState,
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
              "New Patient",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 30,
            ),
            Obx(
              () => Center(
                child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 2, color: kSecondaryColor)),
                    child: _addPatientController.selectFile.value == null
                        ? GestureDetector(
                            onTap: () async {
                              _addPatientController.selectFile.value =
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
                              _addPatientController.selectFile.value =
                                  await _filePicker.getImage();
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.memory(
                                  _addPatientController.selectFile.value!,
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
              hintText: "Enter patient email",
              label: "Email",
              controller: widget.emailController,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              hintText: "Enter patient password",
              label: "Password",
              controller: widget.passwordController,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              hintText: "Enter patient name",
              label: "Name",
              controller: widget.nameController,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              hintText: "Enter patient age",
              label: "Age",
              keyboardType: TextInputType.number,
              controller: widget.ageController,
            ),
            const SizedBox(
              height: 15,
            ),
            RadioListTile<String>(
              title: const Text('Male'),
              value: 'Male',
              groupValue: _selectedGender,
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value; // Update the selected gender
                });
              },
            ),
            const SizedBox(
              height: 15,
            ),
            RadioListTile<String>(
              title: const Text('Female'),
              value: 'Female',
              groupValue: _selectedGender,
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value; // Update the selected gender
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

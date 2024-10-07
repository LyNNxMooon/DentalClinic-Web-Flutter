import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/add_patient_controller.dart';
import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_screens/emergency_saving_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/profile_screens/profile_screen.dart';
import 'package:dental_clinic/utils/file_picker_utils.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/navigation_bar_desktop.dart';
import 'package:dental_clinic/widgets/no_connection_desktop_widget.dart';
import 'package:dental_clinic/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _filePicker = FilePickerUtils();
final _addPatientController = Get.put(AddPatientController());
String? _selectedGender;

class DesktopPatientManagementScreen extends StatefulWidget {
  const DesktopPatientManagementScreen({super.key});

  @override
  State<DesktopPatientManagementScreen> createState() =>
      _DesktopPatientManagementScreenState();
}

class _DesktopPatientManagementScreenState
    extends State<DesktopPatientManagementScreen> {
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
      body: connection == "online"
          ? Padding(
              padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const DesktopNavigationBar(
                      title1: "Home",
                      title2: "Emergency",
                      icon: Icons.person_outlined,
                      widget1: HomeScreen(),
                      widget2: EmergencySavingScreen(),
                      widget3: ReceptionistProfileScreen(),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Manage Patients",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
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
                            width: 80,
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
          : const NoConnectionDesktopWidget(),
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
              style: TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height: 40,
            ),
            Obx(
              () => Center(
                child: Container(
                    width: 100,
                    height: 100,
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
                                size: 40,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              _addPatientController.selectFile.value =
                                  await _filePicker.getImage();
                            },
                            child: Container(
                              width: 100,
                              height: 100,
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
              height: 30,
            ),
            CustomTextField(
              hintText: "Enter patient email",
              label: "Email",
              controller: widget.emailController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: "Enter patient password",
              label: "Password",
              controller: widget.passwordController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: "Enter patient name",
              label: "Name",
              controller: widget.nameController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: "Enter patient age",
              label: "Age",
              keyboardType: TextInputType.number,
              controller: widget.ageController,
            ),
            const SizedBox(
              height: 20,
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
              height: 20,
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

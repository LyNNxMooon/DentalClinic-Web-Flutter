// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/controller/add_patient_controller.dart';
import 'package:dental_clinic/controller/appointment_controller.dart';
import 'package:dental_clinic/controller/feed_back_controller.dart';
import 'package:dental_clinic/controller/login_controller.dart';
import 'package:dental_clinic/controller/patient_management_controller.dart';
import 'package:dental_clinic/data/vos/feed_back_vo.dart';
import 'package:dental_clinic/data/vos/patient_vo.dart';
import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_screens/emergency_saving_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/feed_back_screens/feed_back_detail_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/feed_back_screens/feed_back_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/profile_screens/profile_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/treatment_management_screens/treatment_managament_screen.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:dental_clinic/utils/file_picker_utils.dart';
import 'package:dental_clinic/widgets/chatted_patients_dialog.dart';
import 'package:dental_clinic/widgets/error_widget.dart';
import 'package:dental_clinic/widgets/load_fail_widget.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/navigation_bar_desktop.dart';
import 'package:dental_clinic/widgets/no_connection_desktop_widget.dart';
import 'package:dental_clinic/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _filePicker = FilePickerUtils();
final _addPatientController = Get.put(AddPatientController());
final _patientManagementController = Get.put(PatientManagementController());
final _feedbackController = Get.put(FeedBackController());
final _loginController = Get.put(LoginController());

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

  final _adminPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _allergicMedicineController = TextEditingController();

  final _appointmentController = Get.put(AppointmentController());
  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 50), (timer) {
      _appointmentController.alertAppointment(context);
    });
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    startTimer();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _timer?.cancel();
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (connection == "online") {
            showDialog(
              context: context,
              builder: (context) => const ChattedPatientsDialog(),
            );
          }
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(
          Icons.message,
          color: kSecondaryColor,
          size: 40,
        ),
      ),
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
                      icon: Icons.medical_services_outlined,
                      icon2: Icons.person_outlined,
                      widget1: HomeScreen(),
                      widget2: EmergencySavingScreen(),
                      widget3: TreatmentManagementScreen(),
                      widget4: ReceptionistProfileScreen(),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "View Feedbacks",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () =>
                                Get.to(() => const FeedbackScreen()),
                            icon: const Icon(Icons.arrow_forward_ios))
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Obx(
                      () => _feedbackController.displayFeedback.isEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0.1,
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.1),
                              child: const Text(
                                "Choose feedbacks to Display",
                                style: desktopTitleStyle,
                              ),
                            )
                          : SizedBox(
                              height: 265,
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) =>
                                      GestureDetector(
                                        onTap: () => Get.to(() =>
                                            FeedBackDetailScreen(
                                                feedback: _feedbackController
                                                    .displayFeedback[index])),
                                        child: FeedbackCard(
                                            feedback: _feedbackController
                                                .displayFeedback[index]),
                                      ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        width: 20,
                                      ),
                                  itemCount: _feedbackController
                                      .displayFeedback.length),
                            ),
                    ),
                    const SizedBox(
                      height: 30,
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
                              builder: (context) => CheckAdminDialog(
                                  function: () {
                                    _loginController
                                        .checkAdmin(
                                            _adminPasswordController.text,
                                            context)
                                        .then(
                                      (value) {
                                        if (value) {
                                          Get.back();
                                          _loginController.adminEmail.value =
                                              FirebaseAuth.instance.currentUser
                                                      ?.email ??
                                                  "";
                                          _loginController.adminPassword.value =
                                              _adminPasswordController.text;
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                AddPatientDialog(
                                              function: () async {
                                                _addPatientController
                                                    .registerPatients(
                                                        _emailController,
                                                        _passwordController,
                                                        _nameController,
                                                        _ageController,
                                                        _phoneController,
                                                        _addressController,
                                                        _allergicMedicineController,
                                                        _selectedGender ?? '',
                                                        context);
                                              },
                                              emailController: _emailController,
                                              passwordController:
                                                  _passwordController,
                                              ageController: _ageController,
                                              nameController: _nameController,
                                              addressController:
                                                  _addressController,
                                              allergicMedicineController:
                                                  _allergicMedicineController,
                                              phoneController: _phoneController,
                                            ),
                                          );

                                          _adminPasswordController.clear();
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                CustomErrorWidget(
                                              errorMessage: "Auth Fail",
                                              function: () {
                                                Get.back();
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                  passwordController: _adminPasswordController),
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
                    const SizedBox(
                      height: 40,
                    ),
                    Obx(
                      () => LoadingStateWidget(
                          paddingTop: MediaQuery.of(context).size.height * 0.1,
                          paddingBottom:
                              MediaQuery.of(context).size.height * 0.1,
                          loadingState:
                              _patientManagementController.getLoadingState,
                          loadingSuccessWidget: PatientList(
                            patients: _patientManagementController.patientList,
                          ),
                          loadingInitWidget: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.1,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.1),
                            child: LoadFailWidget(
                              function: () {
                                _patientManagementController.callPatients();
                              },
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            )
          : const NoConnectionDesktopWidget(),
    );
  }
}

class CheckAdminDialog extends StatelessWidget {
  const CheckAdminDialog(
      {super.key, required this.function, required this.passwordController});

  final VoidCallback function;

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        actions: [
          Center(
            child: TextButton(
              onPressed: function,
              style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(kSecondaryColor)),
              child: const Text(
                "OK",
                style: TextStyle(color: kPrimaryColor),
              ),
            ),
          )
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Admin Credentials",
              style: TextStyle(
                  color: kSecondaryColor, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              hintText: "Enter admin password",
              label: "password",
              minLines: 1,
              maxLines: 1,
              isObsecure: true,
              controller: passwordController,
            ),
          ],
        ));
  }
}

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({super.key, required this.feedback});

  final FeedBackVO feedback;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.all(7),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
        borderRadius: BorderRadius.circular(8), //border corner radius
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
            child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: kRateColor,
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      width: 5,
                    ),
                itemCount: feedback.rate),
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "${feedback.patientName} : ",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ])),
          const SizedBox(
            height: 15,
          ),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text:
                        "${feedback.body.length < 200 ? feedback.body : feedback.body.substring(0, 200)}...",
                    style: const TextStyle()),
              ])),
        ],
      ),
    );
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
  bool isDrop = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
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
                                widget.patient.gender,
                                widget.patient.phone,
                                widget.patient.address,
                                widget.patient.allergicMedicine);
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
                                widget.patient.gender,
                                widget.patient.phone,
                                widget.patient.address,
                                widget.patient.allergicMedicine);
                          },
                        ),
                        paddingTop: 0,
                        paddingBottom: 0,
                      ),
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
                                widget.patient.gender,
                                widget.patient.phone,
                                widget.patient.address,
                                widget.patient.allergicMedicine);
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
                                widget.patient.gender,
                                widget.patient.phone,
                                widget.patient.address,
                                widget.patient.allergicMedicine);
                          },
                        ),
                        paddingTop: 0,
                        paddingBottom: 0,
                      ),
                    ),
              const SizedBox(
                width: 60,
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text(widget.patient.name),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text("Age : ${widget.patient.age}"),
                        const SizedBox(
                          height: 15,
                        ),
                        Text("Gender : ${widget.patient.gender}"),
                        const SizedBox(
                          height: 15,
                        ),
                        Text("Phone : ${widget.patient.phone}"),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text("Address : ${widget.patient.address}"),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text(
                                    "Allergic to : ${widget.patient.allergicMedicine}"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(widget.patient.name),
                          ],
                        ),
                      ),
                    )
            ],
          ),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ChatDialog(
                        patientId: widget.patient.id,
                        patientName: widget.patient.name,
                        url: widget.patient.url,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.message_rounded,
                    color: kSecondaryColor,
                  )),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      isDrop = !isDrop;
                    });
                  },
                  child: Icon(
                      isDrop ? Icons.arrow_drop_up : Icons.arrow_drop_down)),
            ],
          )
        ],
      ),
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
                      "Are you sure to unban?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kErrorColor),
                    ),
                  ],
                )),
          );
        },
        icon: const Icon(
          Icons.restore_rounded,
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

class AddPatientDialog extends StatefulWidget {
  const AddPatientDialog({
    super.key,
    required this.function,
    required this.emailController,
    required this.passwordController,
    required this.nameController,
    required this.ageController,
    required this.phoneController,
    required this.addressController,
    required this.allergicMedicineController,
  });

  final VoidCallback function;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController ageController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController allergicMedicineController;

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
              paddingBottom: 0,
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
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: SingleChildScrollView(
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
                validator: Validator.email,
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
              CustomTextField(
                hintText: "Enter patient phone",
                label: "Phone",
                keyboardType: TextInputType.number,
                controller: widget.phoneController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Enter patient address",
                label: "Address",
                controller: widget.addressController,
                minLines: 2,
                maxLines: 4,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Enter patient allergic Medicine",
                label: "Allergic Medicine",
                controller: widget.allergicMedicineController,
                minLines: 3,
                maxLines: 6,
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
      ),
    );
  }
}

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/add_doctor_controller.dart';
import 'package:dental_clinic/controller/receptionist_home_controller.dart';
import 'package:dental_clinic/data/vos/doctor_vo.dart';
import 'package:dental_clinic/screens/receptionist_screens/patient_management_screens/patient_management_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/profile_screens/profile_screen.dart';
import 'package:dental_clinic/utils/file_picker_utils.dart';
import 'package:dental_clinic/widgets/load_fail_widget.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/navigation_bar_desktop.dart';
import 'package:dental_clinic/widgets/no_connection_desktop_widget.dart';
import 'package:dental_clinic/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _filePicker = FilePickerUtils();
final _addDoctorController = Get.put(AddDoctorController());
final _receptionistHomeController = Get.put(ReceptionistHomeController());

class DesktopHomeScreen extends StatefulWidget {
  const DesktopHomeScreen({super.key});

  @override
  State<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  final _doctorNameController = TextEditingController();
  final _doctorSpecialistController = TextEditingController();
  final _doctorExperienceController = TextEditingController();
  final _doctorDayOffController = TextEditingController();
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
        body: connection == "online"
            ? Padding(
                padding: const EdgeInsets.all(50),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const DesktopNavigationBar(
                        title1: "Patients",
                        title2: "Profile",
                        widget1: PatientManagementScreen(),
                        widget2: ReceptionistProfileScreen(),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Available Doctors",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
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
                                          _doctorDayOffController,
                                          context);
                                    } else {
                                      Get.back();
                                    }
                                  },
                                  nameController: _doctorNameController,
                                  bioController: _doctorBiosController,
                                  specController: _doctorSpecialistController,
                                  expController: _doctorExperienceController,
                                  dayOffController: _doctorDayOffController,
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
                      const SizedBox(
                        height: 40,
                      ),
                      Obx(
                        () => LoadingStateWidget(
                            paddingTop: 100,
                            loadingState:
                                _receptionistHomeController.getLoadingState,
                            loadingSuccessWidget: DoctorsList(
                              doctors: _receptionistHomeController.doctorsList,
                            ),
                            loadingInitWidget: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.22),
                              child: LoadFailWidget(
                                function: () {
                                  _receptionistHomeController.callDoctors();
                                },
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              )
            : const NoConnectionDesktopWidget());
  }
}

class DoctorsList extends StatelessWidget {
  const DoctorsList({super.key, required this.doctors});

  final List<DoctorVO> doctors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          width: 15,
        ),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) => GestureDetector(
            onTap: () {},
            child: DoctorCard(
              doctor: doctors[index],
            )),
        itemCount: doctors.length,
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
      width: 200,
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55),
                border: Border.all(width: 0.3),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(55),
                  child: Image.network(
                    doctor.url,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          RichText(
              text: TextSpan(children: [
            const TextSpan(text: "Name : ", style: TextStyle(fontSize: 18)),
            TextSpan(text: doctor.name, style: const TextStyle(fontSize: 18)),
          ])),
          const SizedBox(
            height: 10,
          ),
          RichText(
              text: TextSpan(children: [
            const TextSpan(
                text: "Specialist : ",
                style: TextStyle(fontSize: 14, color: kThirdColor)),
            TextSpan(
                text: doctor.specialist,
                style: const TextStyle(fontSize: 14, color: kThirdColor)),
          ])),
          const SizedBox(
            height: 10,
          ),
          RichText(
              text: TextSpan(children: [
            const TextSpan(
                text: "Experience : ",
                style: TextStyle(fontSize: 14, color: kThirdColor)),
            TextSpan(
                text: doctor.experience,
                style: const TextStyle(fontSize: 14, color: kThirdColor)),
          ])),
          const SizedBox(
            height: 10,
          ),
          RichText(
              text: TextSpan(children: [
            const TextSpan(
                text: "DayOff : ",
                style: TextStyle(fontSize: 14, color: kThirdColor)),
            TextSpan(
                text: doctor.dayOff,
                style: const TextStyle(fontSize: 14, color: kThirdColor)),
          ])),
        ],
      ),
    );
  }
}

class AddDoctorDialog extends StatefulWidget {
  const AddDoctorDialog(
      {super.key,
      required this.function,
      required this.nameController,
      required this.bioController,
      required this.specController,
      required this.expController,
      required this.dayOffController});

  final VoidCallback function;
  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController specController;
  final TextEditingController expController;
  final TextEditingController dayOffController;

  @override
  State<AddDoctorDialog> createState() => _AddDoctorDialogState();
}

class _AddDoctorDialogState extends State<AddDoctorDialog> {
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
              style: TextStyle(fontSize: 28),
            ),
            const SizedBox(
              height: 40,
            ),
            Obx(
              () => Center(
                child: Container(
                    width: 180,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
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
                                size: 40,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              _addDoctorController.selectFile.value =
                                  await _filePicker.getImage();
                            },
                            child: Container(
                              width: 180,
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
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
              height: 30,
            ),
            CustomTextField(
              hintText: "Enter doctor name",
              label: "Name",
              controller: widget.nameController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: "Enter doctor biography",
              label: "Biography",
              controller: widget.bioController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: "Enter doctor specialist",
              label: "Specialist",
              controller: widget.specController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: "Enter doctor experience",
              label: "Experience",
              controller: widget.expController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: "Enter doctor day off",
              label: "Day Off",
              controller: widget.dayOffController,
            ),
          ],
        ),
      ),
    );
  }
}

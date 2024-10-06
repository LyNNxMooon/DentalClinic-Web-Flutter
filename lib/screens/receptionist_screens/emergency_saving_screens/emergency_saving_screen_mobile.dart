import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/add_emergency_saving_controller.dart';
import 'package:dental_clinic/controller/emergency_saving_controller.dart';
import 'package:dental_clinic/data/vos/emergency_saving_vo.dart';
import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_detail_screens/emergency_saving_detail_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_screens/emergency_saving_screen_desktop.dart';
import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen.dart';
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
final _addEmergencySavingController = Get.put(AddEmergencySavingController());
final _emergencySavingController = Get.put(EmergencySavingController());

class MobileEmergencySavingScreen extends StatefulWidget {
  const MobileEmergencySavingScreen({super.key});

  @override
  State<MobileEmergencySavingScreen> createState() =>
      _MobileEmergencySavingScreenState();
}

class _MobileEmergencySavingScreenState
    extends State<MobileEmergencySavingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

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
            title1: "Home",
            title2: "Patients",
            title3: "Profile",
            icon1: Icons.home,
            icon2: Icons.people_alt_outlined,
            icon3: Icons.person,
            widget1: HomeScreen(),
            widget2: PatientManagementScreen(),
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
                          "Emergency Savings",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AddEmergencySavingDialog(
                                function: () async {
                                  if (connection == "online") {
                                    _addEmergencySavingController
                                        .addEmergencySaving(_titleController,
                                            _bodyController, context);
                                  } else {
                                    Get.back();
                                  }
                                },
                                titleController: _titleController,
                                bodyController: _bodyController,
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
                              _emergencySavingController.getLoadingState,
                          loadingSuccessWidget: EmergencySavingList(
                            savings:
                                _emergencySavingController.emergencySavingList,
                          ),
                          loadingInitWidget: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.22),
                            child: LoadFailWidget(
                              function: () {
                                _emergencySavingController
                                    .callEmergencySavings();
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

class EmergencySavingList extends StatelessWidget {
  const EmergencySavingList({super.key, required this.savings});

  final List<EmergencySavingVO> savings;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 0.0,
        mainAxisExtent: 200,
      ),
      itemCount: _emergencySavingController.emergencySavingList.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Get.to(() => EmergencySavingDetailScreen(savingVO: savings[index]));
        },
        child: SavingCard(
          saving: savings[index],
        ),
      ),
    );
  }
}

class SavingCard extends StatelessWidget {
  const SavingCard({super.key, required this.saving});

  final EmergencySavingVO saving;

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
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  saving.url,
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
            TextSpan(text: saving.title, style: const TextStyle(fontSize: 14)),
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
    required this.titleController,
    required this.bodyController,
  });

  final VoidCallback function;
  final TextEditingController titleController;
  final TextEditingController bodyController;

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
              loadingState: _emergencySavingController.getLoadingState,
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
              "New Emergency Saving",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => Center(
                child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(width: 2, color: kSecondaryColor)),
                    child: _addEmergencySavingController.selectFile.value ==
                            null
                        ? GestureDetector(
                            onTap: () async {
                              _addEmergencySavingController.selectFile.value =
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
                              _addEmergencySavingController.selectFile.value =
                                  await _filePicker.getImage();
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.memory(
                                  _addEmergencySavingController
                                      .selectFile.value!,
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
              hintText: "Enter title",
              label: "Title",
              controller: widget.titleController,
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              minLines: 5,
              maxLines: 10,
              hintText: "Enter saving methods",
              label: "Methods",
              controller: widget.bodyController,
            ),
          ],
        ),
      ),
    );
  }
}

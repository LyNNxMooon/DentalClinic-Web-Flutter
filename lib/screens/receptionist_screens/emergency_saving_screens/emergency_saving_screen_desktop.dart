import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/add_emergency_saving_controller.dart';
import 'package:dental_clinic/controller/emergency_saving_controller.dart';
import 'package:dental_clinic/data/vos/emergency_saving_vo.dart';
import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen.dart';
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
final _addEmergencySavingController = Get.put(AddEmergencySavingController());
final _emergencySavingController = Get.put(EmergencySavingController());

class DesktopEmergencySavingScreen extends StatefulWidget {
  const DesktopEmergencySavingScreen({super.key});

  @override
  State<DesktopEmergencySavingScreen> createState() =>
      _DesktopEmergencySavingScreenState();
}

class _DesktopEmergencySavingScreenState
    extends State<DesktopEmergencySavingScreen> {
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
      body: connection == "online"
          ? Padding(
              padding: const EdgeInsets.all(50),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const DesktopNavigationBar(
                      title1: "Home",
                      title2: "Patients",
                      icon: Icons.person_outline,
                      widget1: HomeScreen(),
                      widget2: PatientManagementScreen(),
                      widget3: ReceptionistProfileScreen(),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Emergency Savings",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
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
                                  bodyController: _bodyController),
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
          : const NoConnectionDesktopWidget(),
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
        crossAxisCount: 5,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5,
        mainAxisExtent: 200,
      ),
      itemCount: _emergencySavingController.emergencySavingList.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {},
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
            TextSpan(
                text: saving.title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ])),
        ],
      ),
    );
  }
}

class AddEmergencySavingDialog extends StatefulWidget {
  const AddEmergencySavingDialog({
    super.key,
    required this.function,
    required this.titleController,
    required this.bodyController,
  });

  final VoidCallback function;
  final TextEditingController titleController;
  final TextEditingController bodyController;

  @override
  State<AddEmergencySavingDialog> createState() =>
      _AddEmergencySavingDialogState();
}

class _AddEmergencySavingDialogState extends State<AddEmergencySavingDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Obx(
          () => LoadingStateWidget(
              paddingTop: 0,
              loadingState: _addEmergencySavingController.getLoadingState,
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
                                size: 40,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () async {
                              _addEmergencySavingController.selectFile.value =
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
              height: 30,
            ),
            CustomTextField(
              hintText: "Enter title",
              label: "Title",
              controller: widget.titleController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: "Enter saving methods",
              label: "Methods",
              minLines: 5,
              maxLines: 10,
              controller: widget.bodyController,
            ),
          ],
        ),
      ),
    );
  }
}

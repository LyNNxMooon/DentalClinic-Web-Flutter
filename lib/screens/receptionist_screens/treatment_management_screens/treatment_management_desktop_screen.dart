import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';

import 'package:dental_clinic/controller/treatment_controller.dart';

import 'package:dental_clinic/data/vos/treatment_vo.dart';
import 'package:dental_clinic/screens/receptionist_screens/add_treatment_screens/add_treatment_screen.dart';

import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_screens/emergency_saving_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/patient_management_screens/patient_management_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/profile_screens/profile_screen.dart';
import 'package:dental_clinic/utils/hover_extensions.dart';

import 'package:dental_clinic/widgets/chatted_patients_dialog.dart';
import 'package:dental_clinic/widgets/load_fail_widget.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/navigation_bar_desktop.dart';
import 'package:dental_clinic/widgets/no_connection_desktop_widget.dart';
import 'package:dental_clinic/widgets/textfield.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _treatmentController = Get.put(TreatmentController());

class DesktopTreatmentManagementScreen extends StatefulWidget {
  const DesktopTreatmentManagementScreen({super.key});

  @override
  State<DesktopTreatmentManagementScreen> createState() =>
      _DesktopTreatmentManagementScreenState();
}

class _DesktopTreatmentManagementScreenState
    extends State<DesktopTreatmentManagementScreen> {
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
                      title2: "Patients",
                      icon: Icons.health_and_safety_rounded,
                      icon2: Icons.person_outline,
                      widget1: HomeScreen(),
                      widget2: PatientManagementScreen(),
                      widget3: EmergencySavingScreen(),
                      widget4: ReceptionistProfileScreen(),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Management Treatments",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const AddTreatmentScreen());
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
                          loadingState: _treatmentController.getLoadingState,
                          loadingSuccessWidget: TreatmentList(
                            treatments: _treatmentController.treatmentList,
                          ),
                          loadingInitWidget: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.22),
                            child: LoadFailWidget(
                              function: () {
                                _treatmentController.callTreatments();
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

class TreatmentList extends StatelessWidget {
  const TreatmentList({super.key, required this.treatments});

  final List<TreatmentVO> treatments;

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
      itemCount: treatments.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (context) => TreatmentDialog(treatment: treatments[index]),
        ),
        child: TreatmentCard(
          treatment: treatments[index],
        ).showCursorOnHover.moveUpOnHover,
      ),
    );
  }
}

class TreatmentCard extends StatelessWidget {
  const TreatmentCard({super.key, required this.treatment});

  final TreatmentVO treatment;

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
              const Icon(Icons.medication_outlined),
              const SizedBox(
                height: 15,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: treatment.date,
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
                          text: "Doctor : ${treatment.doctorName}",
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
                          text: "Patient : ${treatment.patientName}",
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
                            text: treatment.treatment,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ])),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              DeleteBtn(function: () {
                _treatmentController.deleteTreatments(treatment.id);
              })
            ],
          ),
        ),
      ),
    );
  }
}

class TreatmentDialog extends StatefulWidget {
  const TreatmentDialog({super.key, required this.treatment});

  final TreatmentVO treatment;

  @override
  State<TreatmentDialog> createState() => _TreatmentDialogState();
}

class _TreatmentDialogState extends State<TreatmentDialog> {
  late TextEditingController treatmentNameController;
  late TextEditingController dosageController;
  late TextEditingController costController;
  late TextEditingController discountController;

  @override
  void initState() {
    treatmentNameController =
        TextEditingController(text: widget.treatment.treatment);
    dosageController = TextEditingController(text: widget.treatment.dosage);
    double initCost =
        widget.treatment.cost / ((widget.treatment.discount / 100));

    costController = TextEditingController(text: initCost.toString());
    discountController =
        TextEditingController(text: widget.treatment.discount.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Obx(
          () => LoadingStateWidget(
              loadingState: _treatmentController.getLoadingState,
              loadingSuccessWidget: Center(
                child: TextButton(
                  onPressed: () {
                    RegExp letterRegExp = RegExp(r'[a-zA-Z]');
                    if (treatmentNameController.text.isNotEmpty ||
                        dosageController.text.isNotEmpty ||
                        costController.text.isNotEmpty ||
                        discountController.text.isNotEmpty ||
                        letterRegExp.hasMatch(costController.text) ||
                        letterRegExp.hasMatch(discountController.text)) {
                      _treatmentController.updateTreatment(
                          widget.treatment.id,
                          widget.treatment.patientID,
                          widget.treatment.patientName,
                          widget.treatment.doctorID,
                          widget.treatment.doctorName,
                          widget.treatment.date,
                          treatmentNameController.text,
                          dosageController.text,
                          double.parse(costController.text),
                          double.parse(discountController.text));
                    }
                  },
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(kSecondaryColor)),
                  child: const Text(
                    "Update",
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ),
              loadingInitWidget: Center(
                child: TextButton(
                  onPressed: () {
                    RegExp letterRegExp = RegExp(r'[a-zA-Z]');
                    if (treatmentNameController.text.isNotEmpty ||
                        dosageController.text.isNotEmpty ||
                        costController.text.isNotEmpty ||
                        discountController.text.isNotEmpty ||
                        letterRegExp.hasMatch(costController.text) ||
                        letterRegExp.hasMatch(discountController.text)) {
                      _treatmentController.updateTreatment(
                          widget.treatment.id,
                          widget.treatment.patientID,
                          widget.treatment.patientName,
                          widget.treatment.doctorID,
                          widget.treatment.doctorName,
                          widget.treatment.date,
                          treatmentNameController.text,
                          dosageController.text,
                          double.parse(costController.text),
                          double.parse(discountController.text));
                    }
                  },
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(kSecondaryColor)),
                  child: const Text(
                    "Update",
                    style: TextStyle(color: kPrimaryColor),
                  ),
                ),
              ),
              paddingTop: 0),
        )
      ],
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Treatment Details",
              style: mobileTitleStyle,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              widget.treatment.date,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Doctor : ${widget.treatment.doctorName}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Patient : ${widget.treatment.patientName}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Final Cost : ${widget.treatment.cost}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomTextField(
              hintText: "Enter Treatment Name",
              label: "Treatment Name",
              controller: treatmentNameController,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: "Enter Medical information and dosage",
              label: "Medical information",
              minLines: 5,
              maxLines: 10,
              controller: dosageController,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  child: CustomTextField(
                    hintText: "Enter Cost",
                    label: "Cost",
                    keyboardType: TextInputType.number,
                    controller: costController,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "\$",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 195,
                  child: CustomTextField(
                    hintText: "Enter discount",
                    label: "Discount",
                    keyboardType: TextInputType.number,
                    controller: discountController,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
          ],
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
                    "Are you sure to delete?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kErrorColor),
                  ),
                ],
              )),
        );
      },
      child: const Text(
        "Delete",
        style: TextStyle(color: kErrorColor),
      ),
    );
  }
}

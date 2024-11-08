// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/controller/add_emergency_saving_controller.dart';
import 'package:dental_clinic/controller/appointment_controller.dart';
import 'package:dental_clinic/controller/chat_controller.dart';
import 'package:dental_clinic/controller/emergency_saving_controller.dart';
import 'package:dental_clinic/controller/pharmacy_controller.dart';
import 'package:dental_clinic/data/vos/emergency_saving_vo.dart';
import 'package:dental_clinic/data/vos/pharmacy_vo.dart';
import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_detail_screens/emergency_saving_detail_screen.dart';

import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/order_screens/order_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/patient_management_screens/patient_management_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/profile_screens/profile_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/treatment_management_screens/treatment_managament_screen.dart';
import 'package:dental_clinic/utils/file_picker_utils.dart';
import 'package:dental_clinic/utils/hover_extensions.dart';
import 'package:dental_clinic/widgets/chatted_patients_dialog.dart';
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
final _pharmacyController = Get.put(PharmacyController());

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
  final _pharmacyNameController = TextEditingController();
  final _priceController = TextEditingController();

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  String connection = "online";

  final _appointmentController = Get.put(AppointmentController());
  final _chatController = Get.put(ChatController());
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
          child: Obx(
            () => Stack(
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.message,
                    color: kSecondaryColor,
                    size: 40,
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kErrorColor),
                    child: Center(
                      child: Text(
                        _chatController.replyNumber.value > 9
                            ? "9+"
                            : _chatController.replyNumber.value.toString(),
                        style:
                            const TextStyle(color: kPrimaryColor, fontSize: 9),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
      key: _scaffoldKey,
      endDrawer: const Drawer(
          backgroundColor: kPrimaryColor,
          child: CustomNavigationDrawer(
            title1: "Home",
            title2: "Patients",
            title3: "Treatments",
            title4: "Profile",
            icon1: Icons.home,
            icon2: Icons.people_alt_outlined,
            icon3: Icons.medical_services_outlined,
            icon4: Icons.person,
            widget1: HomeScreen(),
            widget2: PatientManagementScreen(),
            widget3: TreatmentManagementScreen(),
            widget4: ReceptionistProfileScreen(),
          )),
      body: connection == "online"
          ? Padding(
              padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
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
                        Row(
                          children: [
                            const Text(
                              textAlign: TextAlign.start,
                              "Manage pharmacy",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: TextButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(kBtnGrayColor),
                                      foregroundColor:
                                          WidgetStatePropertyAll(kFourthColor)),
                                  onPressed: () =>
                                      Get.to(() => const OrderScreen()),
                                  child: const Text("Orders")),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AddPharmacyDialog(
                                  function: () async {
                                    if (connection == "online") {
                                      _pharmacyController.addPharmacy(
                                          _pharmacyNameController,
                                          _priceController,
                                          context);
                                    } else {
                                      Get.back();
                                    }
                                  },
                                  nameController: _pharmacyNameController,
                                  priceController: _priceController),
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
                          paddingTop: MediaQuery.of(context).size.height * 0.07,
                          paddingBottom:
                              MediaQuery.of(context).size.height * 0.07,
                          loadingState: _pharmacyController.getLoadingState,
                          loadingSuccessWidget: PharmacyList(
                            pharmacies: _pharmacyController.pharmacies,
                          ),
                          loadingInitWidget: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.07,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.07),
                            child: LoadFailWidget(
                              function: () {
                                _pharmacyController.callPharmacy();
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
                          paddingTop: MediaQuery.of(context).size.height * 0.07,
                          paddingBottom:
                              MediaQuery.of(context).size.height * 0.07,
                          loadingState:
                              _emergencySavingController.getLoadingState,
                          loadingSuccessWidget: EmergencySavingList(
                            savings:
                                _emergencySavingController.emergencySavingList,
                          ),
                          loadingInitWidget: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.07,
                                bottom:
                                    MediaQuery.of(context).size.height * 0.07),
                            child: LoadFailWidget(
                              function: () {
                                _emergencySavingController
                                    .callEmergencySavings();
                              },
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            )
          : const NoConnectionMobileWidget(),
    );
  }
}

class PharmacyList extends StatelessWidget {
  const PharmacyList({super.key, required this.pharmacies});

  final List<PharmacyVO> pharmacies;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          width: 25,
        ),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) =>
                    UpdatePharmacyDialog(pharmacy: pharmacies[index]),
              );
            },
            child: PharmacyCard(pharmacy: pharmacies[index]).showCursorOnHover),
        itemCount: pharmacies.length,
      ),
    );
  }
}

class UpdatePharmacyDialog extends StatefulWidget {
  const UpdatePharmacyDialog({super.key, required this.pharmacy});

  final PharmacyVO pharmacy;

  @override
  State<UpdatePharmacyDialog> createState() => _UpdatePharmacyDialogState();
}

class _UpdatePharmacyDialogState extends State<UpdatePharmacyDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.pharmacy.name);
    _priceController =
        TextEditingController(text: widget.pharmacy.price.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Obx(
          () => LoadingStateWidget(
              paddingBottom: 0,
              paddingTop: 0,
              loadingState: _pharmacyController.getLoadingState,
              loadingSuccessWidget: Center(
                child: TextButton(
                  onPressed: () {
                    _pharmacyController.updatePharmacy(
                        widget.pharmacy.id,
                        _nameController.text,
                        _priceController.text,
                        widget.pharmacy.url,
                        context);
                  },
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(kSecondaryColor)),
                  child: const Text(
                    "Update",
                    style: TextStyle(color: kFourthColor),
                  ),
                ),
              ),
              loadingInitWidget: Center(
                child: TextButton(
                  onPressed: () {
                    _pharmacyController.updatePharmacy(
                        widget.pharmacy.id,
                        _nameController.text,
                        _priceController.text,
                        widget.pharmacy.url,
                        context);
                  },
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(kSecondaryColor)),
                  child: const Text(
                    "Update",
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
            children: [
              const Text(
                "Update Pharmacy",
                style: mobileTitleStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Enter Pharmacy Name",
                label: "Name",
                controller: _nameController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Enter Price (Ks)",
                label: "Price (Ks)",
                controller: _priceController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PharmacyCard extends StatelessWidget {
  const PharmacyCard({super.key, required this.pharmacy});

  final PharmacyVO pharmacy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
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
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 0.3),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    pharmacy.url,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: pharmacy.name,
                  ),
                ])),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: "${pharmacy.price} Ks",
                  ),
                ])),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
              onTap: () {
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
                              onPressed: () {
                                _pharmacyController.deletePharmacy(pharmacy.id);
                              },
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
              child: const Icon(
                Icons.delete,
                color: kErrorColor,
              ))
        ],
      ),
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
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: saving.title,
                        style: const TextStyle(fontSize: 14)),
                  ])),
                ],
              ),
            ),
          ),
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
              paddingBottom: 0,
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
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
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
      ),
    );
  }
}

class AddPharmacyDialog extends StatefulWidget {
  const AddPharmacyDialog({
    super.key,
    required this.function,
    required this.nameController,
    required this.priceController,
  });

  final VoidCallback function;
  final TextEditingController nameController;
  final TextEditingController priceController;

  @override
  State<AddPharmacyDialog> createState() => _AddPharmacyDialogState();
}

class _AddPharmacyDialogState extends State<AddPharmacyDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Obx(
          () => LoadingStateWidget(
              paddingBottom: 0,
              paddingTop: 0,
              loadingState: _pharmacyController.getLoadingState,
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
                "New Pharmacy",
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
                      child: _pharmacyController.selectFile.value == null
                          ? GestureDetector(
                              onTap: () async {
                                _pharmacyController.selectFile.value =
                                    await _filePicker.getImage();
                              },
                              child: const Center(
                                child: Icon(
                                  Icons.add_a_photo_outlined,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                _pharmacyController.selectFile.value =
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
                                    _pharmacyController.selectFile.value!,
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
                hintText: "Enter name",
                label: "Name",
                controller: widget.nameController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Enter Price (Ks)",
                label: "Price (Ks)",
                controller: widget.priceController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

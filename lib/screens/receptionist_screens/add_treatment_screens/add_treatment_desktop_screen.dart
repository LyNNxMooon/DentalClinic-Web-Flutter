// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';

import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/controller/payment_controller.dart';
import 'package:dental_clinic/controller/treatment_controller.dart';
import 'package:dental_clinic/data/vos/appointment_vo.dart';
import 'package:dental_clinic/data/vos/payment_vo.dart';
import 'package:dental_clinic/utils/file_picker_utils.dart';
import 'package:dental_clinic/utils/hover_extensions.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';

import 'package:dental_clinic/widgets/no_connection_desktop_widget.dart';
import 'package:dental_clinic/widgets/textfield.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _treatmentController = Get.put(TreatmentController());
final _paymentController = Get.put(PaymentController());
final _filePicker = FilePickerUtils();

String? _paymentStatus;

class DesktopAddTreatmentScreen extends StatefulWidget {
  const DesktopAddTreatmentScreen({super.key});

  @override
  State<DesktopAddTreatmentScreen> createState() =>
      _DesktopAddTreatmentScreenState();
}

class _DesktopAddTreatmentScreenState extends State<DesktopAddTreatmentScreen> {
  final _treatmentNameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _costController = TextEditingController();
  final _discountController = TextEditingController();
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  String connection = "online";

  List<PaymentVO> payments = [];

  bool isDrop = false;

  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _treatmentController.getTodayAppointments();

    payments = _paymentController.payments;

    payments.add(PaymentVO(
        id: 0,
        accountName: "Cash",
        accountNumber: "",
        type: "Cash",
        url:
            "https://www.shutterstock.com/image-vector/transparent-money-icon-png-vector-600nw-1946627578.jpg"));
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  String formatTime(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.arrow_back)),
                        const Text(
                          "Add Treatment",
                          style: desktopTitleStyle,
                        ),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    const Text(
                      "Select Appoint to add treatment",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Obx(
                      () => _treatmentController.todayAppointments.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.only(top: 60),
                              child: Center(
                                child: Text(
                                  "No Appointments for today",
                                  style: mobileTitleStyle,
                                ),
                              ),
                            )
                          : AppointmentList(
                              appointments:
                                  _treatmentController.todayAppointments),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kBtnGrayColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1), // Shadow color
                                  spreadRadius: 3, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset: const Offset(
                                      0, 3), // Offset of the shadow
                                ),
                              ],
                            ),
                            child: RichText(
                                text: TextSpan(children: [
                              const TextSpan(
                                  text: "Doctor : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              TextSpan(
                                  text: _treatmentController
                                              .selectedAppointment.value ==
                                          null
                                      ? " - "
                                      : _treatmentController.selectedAppointment
                                          .value!.doctorName,
                                  style: const TextStyle(fontSize: 18)),
                            ])),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kBtnGrayColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.1), // Shadow color
                                  spreadRadius: 3, // Spread radius
                                  blurRadius: 5, // Blur radius
                                  offset: const Offset(
                                      0, 3), // Offset of the shadow
                                ),
                              ],
                            ),
                            child: RichText(
                                text: TextSpan(children: [
                              const TextSpan(
                                  text: "Patient : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              TextSpan(
                                  text: _treatmentController
                                              .selectedAppointment.value ==
                                          null
                                      ? " - "
                                      : _treatmentController.selectedAppointment
                                          .value!.patientName,
                                  style: const TextStyle(fontSize: 18)),
                            ])),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kBtnGrayColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // Shadow color
                                spreadRadius: 3, // Spread radius
                                blurRadius: 5, // Blur radius
                                offset:
                                    const Offset(0, 3), // Offset of the shadow
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                selectedTime == null
                                    ? 'Select Time'
                                    : selectedTime!.format(context),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                  onTap: () => _selectTime(context),
                                  child: const Icon(Icons.timelapse_outlined))
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.16),
                      child: Center(
                        child: CustomTextField(
                          hintText: "Enter Treatment Name",
                          label: "Treatment Name",
                          controller: _treatmentNameController,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.16),
                      child: Center(
                        child: CustomTextField(
                          hintText: "Enter Medical Information and dosage",
                          label: "Medical Information",
                          minLines: 5,
                          maxLines: 10,
                          controller: _dosageController,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: CustomTextField(
                                hintText: "Enter Cost (Ks)",
                                label: "Cost (Ks)",
                                keyboardType: TextInputType.number,
                                controller: _costController,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: SizedBox(
                              child: CustomTextField(
                                hintText: "Discount %",
                                label: "Discount %",
                                keyboardType: TextInputType.number,
                                controller: _discountController,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Paid'),
                              value: 'Paid',
                              groupValue: _paymentStatus,
                              onChanged: (String? value) {
                                setState(() {
                                  _paymentStatus = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Un-paid'),
                              value: 'un-paid',
                              groupValue: _paymentStatus,
                              onChanged: (String? value) {
                                setState(() {
                                  _paymentStatus = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _paymentStatus == "Paid"
                        ? Obx(() => selectPaymentTile(context))
                        : const SizedBox(),
                    isDrop
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    paymentTile(context, payments[index]),
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 10,
                                    ),
                                itemCount: payments.length),
                          )
                        : const SizedBox(),
                    _paymentStatus == "Paid" &&
                            _treatmentController
                                    .selectedPayment.value?.accountName !=
                                "Cash"
                        ? Obx(() => slipBox(context))
                        : const SizedBox(),
                    Obx(
                      () => LoadingStateWidget(
                          loadingState: _treatmentController.getLoadingState,
                          loadingSuccessWidget: AddBtn(function: () {
                            _treatmentController.addTreatment(
                                _treatmentNameController,
                                _dosageController,
                                _costController,
                                _discountController,
                                selectedTime?.format(context) ?? "",
                                _paymentStatus ?? "",
                                context);
                          }),
                          loadingInitWidget: AddBtn(function: () {
                            _treatmentController.addTreatment(
                                _treatmentNameController,
                                _dosageController,
                                _costController,
                                _discountController,
                                selectedTime?.format(context) ?? "",
                                _paymentStatus ?? "",
                                context);
                          }),
                          paddingTop: 0),
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

  Widget slipBox(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.16, vertical: 20),
        height: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1)),
        child: _treatmentController.selectFile.value == null
            ? GestureDetector(
                onTap: () async {
                  _treatmentController.selectFile.value =
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
                  _treatmentController.selectFile.value =
                      await _filePicker.getImage();
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.memory(
                    _treatmentController.selectFile.value!,
                    fit: BoxFit.contain,
                  ),
                ),
              ));
  }

  Widget selectPaymentTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.16,
          right: MediaQuery.of(context).size.width * 0.16,
          bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _treatmentController.selectedPayment.value == null
              ? const Text(
                  "Select Payment",
                  style: TextStyle(color: kThirdColor),
                )
              : SizedBox(
                  width: 200,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
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
                              _treatmentController.selectedPayment.value!.url,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(_treatmentController
                            .selectedPayment.value!.accountName),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                            "/ ${_treatmentController.selectedPayment.value!.accountNumber}"),
                      ],
                    ),
                  ),
                ),
          IconButton(
              onPressed: () {
                setState(() {
                  isDrop = !isDrop;
                });
              },
              icon: isDrop
                  ? const Icon(Icons.arrow_drop_up)
                  : const Icon(Icons.arrow_drop_down))
        ],
      ),
    );
  }

  Widget paymentTile(BuildContext context, PaymentVO payment) {
    return GestureDetector(
      onTap: () {
        _treatmentController.selectedPayment.value = payment;
        setState(() {
          isDrop = !isDrop;
        });
      },
      child: Container(
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.16,
          right: MediaQuery.of(context).size.width * 0.16,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1)),
        child: Row(
          children: [
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
                  payment.url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Text(payment.accountName),
            const SizedBox(
              width: 15,
            ),
            Text("/ ${payment.accountNumber}"),
          ],
        ),
      ),
    );
  }
}

class AddBtn extends StatelessWidget {
  const AddBtn({super.key, required this.function});

  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.16),
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: kSecondaryColor),
        child: const Center(
          child: Text(
            "Add",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class AppointmentList extends StatelessWidget {
  const AppointmentList({super.key, required this.appointments});

  final List<AppointmentVO> appointments;

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
      itemCount: appointments.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          _treatmentController.selectedAppointment.value = appointments[index];
        },
        child: AppointmentCard(
          appointment: appointments[index],
        ).showCursorOnHover.moveUpOnHover,
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key, required this.appointment});

  final AppointmentVO appointment;

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
              const Icon(Icons.date_range),
              const SizedBox(
                height: 15,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: appointment.date,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ])),
              const SizedBox(
                height: 15,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: appointment.time,
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
                          text: "Doctor : ${appointment.doctorName}",
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
                          text: "Patient : ${appointment.patientName}",
                        ),
                      ])),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

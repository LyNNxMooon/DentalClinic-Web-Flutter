import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/controller/treatment_controller.dart';
import 'package:dental_clinic/data/vos/payment_vo.dart';
import 'package:dental_clinic/data/vos/treatment_vo.dart';
import 'package:dental_clinic/utils/hover_extensions.dart';
import 'package:dental_clinic/widgets/load_fail_widget.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/no_connection_desktop_widget.dart';
import 'package:dental_clinic/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

List<TreatmentVO> filteredTreatments = <TreatmentVO>[];

final _treatmentController = Get.put(TreatmentController());

class AllTreatmentScreen extends StatefulWidget {
  const AllTreatmentScreen({super.key});

  @override
  State<AllTreatmentScreen> createState() => _AllTreatmentScreenState();
}

class _AllTreatmentScreenState extends State<AllTreatmentScreen> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  String connection = "online";

  @override
  void initState() {
    super.initState();
    initConnectivity();
    filteredTreatments = _treatmentController.treatmentList;
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _treatmentController.date.value =
            DateFormat('yMMMMd').format(pickedDate);
        filterTreatments();
      });
    }
  }

  void filterTreatments() {
    List<TreatmentVO> treatmentsByDate = <TreatmentVO>[];
    for (TreatmentVO treatment in _treatmentController.treatmentList) {
      if (treatment.date == _treatmentController.date.value) {
        treatmentsByDate.add(treatment);
      }
    }
    setState(() {
      filteredTreatments = treatmentsByDate;
    });
  }

  void clearFilteredTreatments() {
    setState(() {
      _treatmentController.date.value = "";
      filteredTreatments = _treatmentController.treatmentList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  icon: const Icon(Icons.date_range)),
              const Gap(20)
            ],
            centerTitle: true,
            title: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _treatmentController.date.value.isEmpty
                        ? "All Treatments"
                        : _treatmentController.date.value,
                    style: desktopTitleStyle,
                  ),
                  _treatmentController.date.value.isEmpty
                      ? const SizedBox()
                      : IconButton(
                          onPressed: () => clearFilteredTreatments(),
                          icon: const Icon(Icons.clear))
                ],
              ),
            )),
        body: connection == "online"
            ? Padding(
                padding: const EdgeInsets.all(30),
                child: filteredTreatments.isEmpty
                    ? const Center(
                        child: Text(
                          "No treatments on this date!",
                          style: mobileTitleStyle,
                        ),
                      )
                    : Obx(
                        () => LoadingStateWidget(
                            paddingTop:
                                MediaQuery.of(context).size.height * 0.1,
                            paddingBottom:
                                MediaQuery.of(context).size.height * 0.1,
                            loadingState: _treatmentController.getLoadingState,
                            loadingSuccessWidget: TreatmentList(
                              treatments: filteredTreatments,
                            ),
                            loadingInitWidget: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0.1,
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.1),
                              child: LoadFailWidget(
                                function: () {
                                  _treatmentController.callTreatments();
                                },
                              ),
                            )),
                      ),
              )
            : const NoConnectionDesktopWidget(),
      ),
    );
  }
}

class TreatmentList extends StatefulWidget {
  const TreatmentList({super.key, required this.treatments});

  final List<TreatmentVO> treatments;

  @override
  State<TreatmentList> createState() => _TreatmentListState();
}

class _TreatmentListState extends State<TreatmentList> {
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
      itemCount: widget.treatments.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (context) =>
              TreatmentDialog(treatment: widget.treatments[index]),
        ),
        child: TreatmentCard(
          treatment: widget.treatments[index],
        ).showCursorOnHover.moveUpOnHover,
      ),
    );
  }
}

class TreatmentCard extends StatefulWidget {
  const TreatmentCard({super.key, required this.treatment});

  final TreatmentVO treatment;

  @override
  State<TreatmentCard> createState() => _TreatmentCardState();
}

class _TreatmentCardState extends State<TreatmentCard> {
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
                    text: widget.treatment.date,
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
                          text: "Doctor : ${widget.treatment.doctorName}",
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
                          text: "Patient : ${widget.treatment.patientName}",
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
                            text: widget.treatment.treatment,
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
                _treatmentController.deleteTreatments(widget.treatment.id);
                setState(() {
                  _treatmentController.date.value = "";
                  filteredTreatments = _treatmentController.treatmentList;
                });
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

  String? _paymentStatus;

  bool isDrop = false;

  List<PaymentVO> payments = [];

  @override
  void initState() {
    treatmentNameController =
        TextEditingController(text: widget.treatment.treatment);
    dosageController = TextEditingController(text: widget.treatment.dosage);
    double initCost = widget.treatment.discount == 0
        ? widget.treatment.cost
        : widget.treatment.cost / (1 - (widget.treatment.discount / 100));

    costController = TextEditingController(text: initCost.toString());
    discountController =
        TextEditingController(text: widget.treatment.discount.toString());

    setPaymentStatus();
    populatePayments();

    super.initState();
  }

  setPaymentStatus() {
    setState(() {
      _paymentStatus = widget.treatment.paymentStatus;
    });
  }

  populatePayments() {
    payments.clear();

    payments = [];
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
                        double.parse(discountController.text),
                        widget.treatment.time,
                        _paymentStatus!,
                        widget.treatment.slip,
                        widget.treatment.paymentType);

                    setState(() {
                      _treatmentController.date.value = "";
                      filteredTreatments = _treatmentController.treatmentList;
                    });
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
                        double.parse(discountController.text),
                        widget.treatment.time,
                        _paymentStatus!,
                        widget.treatment.slip,
                        widget.treatment.paymentType);

                    setState(() {
                      _treatmentController.date.value = "";
                      filteredTreatments = _treatmentController.treatmentList;
                    });
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
            paddingTop: 0,
            paddingBottom: 0,
          ),
        )
      ],
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: SingleChildScrollView(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.treatment.date,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " , ${widget.treatment.time}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Doctor : ${widget.treatment.doctorName}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " , Patient : ${widget.treatment.patientName}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Final Cost : ${widget.treatment.cost}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " , Payment : ${widget.treatment.paymentType.isEmpty && widget.treatment.paymentStatus == "Paid" ? "Cash" : widget.treatment.paymentType.isEmpty && widget.treatment.paymentStatus == "Un-paid" ? "Un-paid" : widget.treatment.paymentType}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.15),
                child: CustomTextField(
                  hintText: "Enter Treatment Name",
                  label: "Treatment Name",
                  controller: treatmentNameController,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.15),
                child: CustomTextField(
                  hintText: "Enter Medical information and dosage",
                  label: "Medical information",
                  minLines: 5,
                  maxLines: 10,
                  controller: dosageController,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: CustomTextField(
                          hintText: "Enter Cost (Ks)",
                          label: "Cost (Ks)",
                          keyboardType: TextInputType.number,
                          controller: costController,
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
                          controller: discountController,
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
                    horizontal: MediaQuery.of(context).size.width * 0.15),
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
                        value: 'Un-paid',
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
              slipBox(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget slipBox(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.15, vertical: 20),
        height: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            widget.treatment.slip.isEmpty
                ? "https://thumbs.dreamstime.com/b/sad-document-no-data-file-icon-white-334021734.jpg"
                : widget.treatment.slip,
            fit: BoxFit.contain,
          ),
        ));
  }

  Widget selectPaymentTile(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.15,
          right: MediaQuery.of(context).size.width * 0.15,
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
                  "Select Payment to update",
                  style: TextStyle(color: kThirdColor),
                )
              : SizedBox(
                  width: 180,
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
          left: MediaQuery.of(context).size.width * 0.15,
          right: MediaQuery.of(context).size.width * 0.15,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1)),
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

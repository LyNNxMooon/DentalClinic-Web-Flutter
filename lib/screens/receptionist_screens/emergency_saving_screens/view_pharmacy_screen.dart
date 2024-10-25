// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/controller/pharmacy_controller.dart';
import 'package:dental_clinic/data/vos/pharmacy_vo.dart';
import 'package:dental_clinic/utils/hover_extensions.dart';
import 'package:dental_clinic/widgets/load_fail_widget.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/no_connection_desktop_widget.dart';
import 'package:dental_clinic/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _pharmacyController = Get.put(PharmacyController());

class ViewPharmacyScreen extends StatefulWidget {
  const ViewPharmacyScreen({super.key});

  @override
  State<ViewPharmacyScreen> createState() => _ViewPharmacyScreenState();
}

class _ViewPharmacyScreenState extends State<ViewPharmacyScreen> {
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
              padding: const EdgeInsets.all(40),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back)),
                      const Text(
                        textAlign: TextAlign.start,
                        "Pharmacies",
                        style: desktopTitleStyle,
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Obx(
                    () => LoadingStateWidget(
                        paddingTop: MediaQuery.of(context).size.height * 0.1,
                        paddingBottom: MediaQuery.of(context).size.height * 0.1,
                        loadingState: _pharmacyController.getLoadingState,
                        loadingSuccessWidget: PharmacyList(
                          pharmacies: _pharmacyController.pharmacies,
                        ),
                        loadingInitWidget: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.1,
                              bottom: MediaQuery.of(context).size.height * 0.1),
                          child: LoadFailWidget(
                            function: () {
                              _pharmacyController.callPharmacy();
                            },
                          ),
                        )),
                  ),
                ],
              ),
            )
          : const NoConnectionDesktopWidget(),
    );
  }
}

class PharmacyList extends StatelessWidget {
  const PharmacyList({super.key, required this.pharmacies});

  final List<PharmacyVO> pharmacies;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        mainAxisExtent: 190,
      ),
      itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) =>
                  UpdatePharmacyDialog(pharmacy: pharmacies[index]),
            );
          },
          child: PharmacyCard(pharmacy: pharmacies[index])
              .showCursorOnHover
              .moveUpOnHover),
      itemCount: pharmacies.length,
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
                style: desktopTitleStyle,
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

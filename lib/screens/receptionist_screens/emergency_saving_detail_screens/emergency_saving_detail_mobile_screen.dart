// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';

import 'package:dental_clinic/controller/emergency_saving_detail_controller.dart';
import 'package:dental_clinic/data/vos/emergency_saving_vo.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/no_connection_mobile_widget.dart';
import 'package:dental_clinic/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _emergencySavingDetailController =
    Get.put(EmergencySavingDetailController());

late TextEditingController _tileController;

late TextEditingController _bodyController;

class EmergencySavingMobileScreen extends StatefulWidget {
  const EmergencySavingMobileScreen({super.key, required this.saving});

  final EmergencySavingVO saving;

  @override
  State<EmergencySavingMobileScreen> createState() =>
      _EmergencySavingMobileScreenState();
}

class _EmergencySavingMobileScreenState
    extends State<EmergencySavingMobileScreen> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  String connection = "online";

  @override
  void initState() {
    _tileController = TextEditingController(text: widget.saving.title);
    _bodyController = TextEditingController(text: widget.saving.body);

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
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
              padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
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
                      Obx(
                        () => LoadingStateWidget(
                            paddingBottom: 0,
                            loadingState: _emergencySavingDetailController
                                .getLoadingState,
                            loadingSuccessWidget: DeleteBtn(
                              function: () {
                                _emergencySavingDetailController
                                    .deleteEmergencySaving(widget.saving.id);
                              },
                            ),
                            loadingInitWidget: DeleteBtn(
                              function: () {
                                _emergencySavingDetailController
                                    .deleteEmergencySaving(widget.saving.id);
                              },
                            ),
                            paddingTop: 0),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Emergency Saving Details",
                    style: mobileTitleStyle,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
                            widget.saving.url,
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: CustomTextField(
                      hintText: "Enter Title",
                      label: "Title",
                      controller: _tileController,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.1),
                    child: CustomTextField(
                      hintText: "Enter saving methods",
                      label: "Methods",
                      minLines: 5,
                      maxLines: 10,
                      controller: _bodyController,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Obx(
                    () => LoadingStateWidget(
                        paddingBottom: 0,
                        loadingState:
                            _emergencySavingDetailController.getLoadingState,
                        loadingSuccessWidget: UpdateBtn(
                            id: widget.saving.id, url: widget.saving.url),
                        loadingInitWidget: UpdateBtn(
                            id: widget.saving.id, url: widget.saving.url),
                        paddingTop: 0),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                ],
              )),
            )
          : const NoConnectionMobileWidget(),
    );
  }
}

class DeleteBtn extends StatelessWidget {
  const DeleteBtn({super.key, required this.function});

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
                        width: 15,
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
                      height: 15,
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
        icon: const Icon(
          Icons.delete,
          color: kErrorColor,
        ));
  }
}

class UpdateBtn extends StatelessWidget {
  const UpdateBtn({super.key, required this.id, required this.url});

  final int id;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _emergencySavingDetailController.updateEmergencySaving(
            id,
            url,
            _tileController.text,
            _bodyController.text,
          );
        },
        child: Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
              color: kSecondaryColor, borderRadius: BorderRadius.circular(10)),
          child: const Center(
            child: Text(
              "Update",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

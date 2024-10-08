import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/widgets/no_connection_mobile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAppointmentMobileScreen extends StatefulWidget {
  const AddAppointmentMobileScreen({super.key});

  @override
  State<AddAppointmentMobileScreen> createState() =>
      _AddAppointmentMobileScreenState();
}

class _AddAppointmentMobileScreenState
    extends State<AddAppointmentMobileScreen> {
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
              padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.arrow_back)),
                        const Text(
                          "Add Appointment",
                          style: mobileTitleStyle,
                        ),
                        const SizedBox(
                          width: 20,
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          : const NoConnectionMobileWidget(),
    );
  }
}

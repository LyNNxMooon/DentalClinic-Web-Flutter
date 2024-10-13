import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/screens/receptionist_screens/auth_page.dart';
import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_screens/emergency_saving_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/home_screen/home_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/patient_management_screens/patient_management_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/treatment_management_screens/treatment_managament_screen.dart';

import 'package:dental_clinic/widgets/navigation_bar_mobile.dart';
import 'package:dental_clinic/widgets/no_connection_mobile_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileReceptionistProfileScreen extends StatefulWidget {
  const MobileReceptionistProfileScreen({super.key});

  @override
  State<MobileReceptionistProfileScreen> createState() =>
      _MobileReceptionistProfileScreenState();
}

class _MobileReceptionistProfileScreenState
    extends State<MobileReceptionistProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final userEmail = FirebaseAuth.instance.currentUser;
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
            title3: "Treatments",
            title4: "Emergency",
            icon1: Icons.home,
            icon2: Icons.people_alt_outlined,
            icon3: Icons.medical_services_outlined,
            icon4: Icons.emergency_outlined,
            widget1: HomeScreen(),
            widget2: PatientManagementScreen(),
            widget3: TreatmentManagementScreen(),
            widget4: EmergencySavingScreen(),
          )),
      body: connection == "online"
          ? Padding(
              padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MobileNavigationBar(
                      scaffoldKey: _scaffoldKey,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      textAlign: TextAlign.start,
                      "Profile",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          border: Border.all(width: 1)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: Image.asset(
                          "assets/images/doctor_placeholder.jpg",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: "Login Email : ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: userEmail?.email,
                          style: const TextStyle(fontSize: 16)),
                    ])),
                    const SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.signOut().then(
                              (value) => Get.offAll(() => const AuthPage()),
                            );
                      },
                      child: Container(
                        width: 180,
                        height: 50,
                        decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            "Log Out",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          : const NoConnectionMobileWidget(),
    );
  }
}

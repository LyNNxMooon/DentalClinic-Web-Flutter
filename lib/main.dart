// ignore_for_file: avoid_print

import 'dart:async';

import 'package:dental_clinic/controller/appointment_controller.dart';
import 'package:dental_clinic/screens/receptionist_screens/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyB1aJxj0U_434B_1iXXef8KXDcGrSXhpkw",
        authDomain: "dental-clinic-9cbf2.firebaseapp.com",
        databaseURL: "https://dental-clinic-9cbf2-default-rtdb.firebaseio.com",
        projectId: "dental-clinic-9cbf2",
        storageBucket: "dental-clinic-9cbf2.appspot.com",
        messagingSenderId: "582817729094",
        appId: "1:582817729094:web:db6e1049f5a0f3e0a05847"),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appointmentController = Get.put(AppointmentController());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 50), (timer) {
      _appointmentController.callAppointments();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dental Clinic',
      theme: ThemeData(fontFamily: "Ubuntu"),
      home: const AuthPage(),
    );
  }
}

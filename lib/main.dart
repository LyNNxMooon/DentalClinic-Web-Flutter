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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

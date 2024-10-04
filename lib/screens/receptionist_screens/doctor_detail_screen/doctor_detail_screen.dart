import 'package:dental_clinic/data/vos/doctor_vo.dart';
import 'package:dental_clinic/responsive/responsive_layout.dart';
import 'package:dental_clinic/screens/receptionist_screens/doctor_detail_screen/doctor_detail_desktop_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/doctor_detail_screen/doctor_detail_mobile_screen.dart';
import 'package:flutter/material.dart';

class DoctorDetailScreen extends StatelessWidget {
  const DoctorDetailScreen({super.key, required this.doctor});

  final DoctorVO doctor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
          mobileBody: DoctorDetailMobileScreen(
            doctor: doctor,
          ),
          desktopBody: DoctorDetailDesktopScreen(
            doctor: doctor,
          )),
    );
  }
}

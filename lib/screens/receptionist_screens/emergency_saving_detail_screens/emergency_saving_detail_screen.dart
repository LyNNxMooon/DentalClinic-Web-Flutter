import 'package:dental_clinic/data/vos/emergency_saving_vo.dart';
import 'package:dental_clinic/responsive/responsive_layout.dart';
import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_detail_screens/emergency_saving_detail_desktop_screen.dart';

import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_detail_screens/emergency_saving_detail_mobile_screen.dart';
import 'package:flutter/material.dart';

class EmergencySavingDetailScreen extends StatelessWidget {
  const EmergencySavingDetailScreen({super.key, required this.savingVO});

  final EmergencySavingVO savingVO;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
          mobileBody: EmergencySavingMobileScreen(
            saving: savingVO,
          ),
          desktopBody: EmergencySavingDesktopScreen(
            saving: savingVO,
          )),
    );
  }
}

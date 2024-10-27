import 'package:dental_clinic/responsive/responsive_layout.dart';
import 'package:dental_clinic/screens/receptionist_screens/order_screens/order_screen_desktop.dart';
import 'package:dental_clinic/screens/receptionist_screens/order_screens/order_screen_mobile.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileBody: MobileOrderScreen(), desktopBody: DesktopOrderScreen()),
    );
  }
}

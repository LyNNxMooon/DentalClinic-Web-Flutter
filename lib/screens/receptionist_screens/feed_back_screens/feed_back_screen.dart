import 'package:dental_clinic/responsive/responsive_layout.dart';
import 'package:dental_clinic/screens/receptionist_screens/feed_back_screens/feed_back_desktop_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/feed_back_screens/feed_back_mobile_screen.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileBody: MobileFeedbackScreen(),
          desktopBody: DesktopFeedbackScreen()),
    );
  }
}

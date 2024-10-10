import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/controller/feed_back_controller.dart';
import 'package:dental_clinic/data/vos/feed_back_vo.dart';
import 'package:dental_clinic/screens/receptionist_screens/feed_back_screens/feed_back_detail_screen.dart';
import 'package:dental_clinic/utils/hover_extensions.dart';
import 'package:dental_clinic/widgets/load_fail_widget.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/no_connection_mobile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _feedbackController = Get.put(FeedBackController());

class MobileFeedbackScreen extends StatefulWidget {
  const MobileFeedbackScreen({super.key});

  @override
  State<MobileFeedbackScreen> createState() => _MobileFeedbackScreenState();
}

class _MobileFeedbackScreenState extends State<MobileFeedbackScreen> {
  @override
  void initState() {
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  String connection = "online";

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
                        textAlign: TextAlign.start,
                        "Mange Feedbacks",
                        style: mobileTitleStyle,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Obx(
                    () => LoadingStateWidget(
                        paddingTop: 70,
                        loadingState: _feedbackController.getLoadingState,
                        loadingSuccessWidget: FeedbackList(
                          feedbacks: _feedbackController.feedbackList,
                        ),
                        loadingInitWidget: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.1),
                          child: LoadFailWidget(
                            function: () {
                              _feedbackController.callFeedBacks();
                            },
                          ),
                        )),
                  ),
                ],
              )),
            )
          : const NoConnectionMobileWidget(),
    );
  }
}

class FeedbackList extends StatelessWidget {
  const FeedbackList({super.key, required this.feedbacks});

  final List<FeedBackVO> feedbacks;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5,
        mainAxisExtent: 300,
      ),
      itemCount: _feedbackController.feedbackList.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          _feedbackController.chooseFeedback(
              feedbacks[index].id,
              feedbacks[index].body,
              feedbacks[index].patientID,
              feedbacks[index].patientName,
              feedbacks[index].display ? false : true,
              feedbacks[index].rate);
        },
        child: FeedbackCard(
          feedback: feedbacks[index],
        ),
      ),
    );
  }
}

class FeedbackCard extends StatelessWidget {
  const FeedbackCard({super.key, required this.feedback});

  final FeedBackVO feedback;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7),
      padding: feedback.display
          ? const EdgeInsets.only(top: 15, right: 15, left: 15)
          : const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(
            width: feedback.display ? 5 : 1,
            color: feedback.display ? kSuccessColor : kFourthColor),
        borderRadius: BorderRadius.circular(8), //border corner radius
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
            child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: kRateColor,
                    ),
                separatorBuilder: (context, index) => const SizedBox(
                      width: 5,
                    ),
                itemCount: feedback.rate),
          ),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: "${feedback.patientName} : ",
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ])),
          RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text:
                        "${feedback.body.length < 60 ? feedback.body : feedback.body.substring(0, 60)}...",
                    style: const TextStyle()),
              ])),
          TextButton(
              onPressed: () {
                Get.to(() => FeedBackDetailScreen(
                      feedback: feedback,
                    ));
              },
              child: const Text(
                "View",
                style: TextStyle(
                    color: kSecondaryColor, fontWeight: FontWeight.bold),
              )),
          feedback.display
              ? const Icon(
                  Icons.check_circle,
                  color: kSuccessColor,
                  size: 20,
                )
              : const SizedBox()
        ],
      ),
    ).showCursorOnHover.moveUpOnHover;
  }
}

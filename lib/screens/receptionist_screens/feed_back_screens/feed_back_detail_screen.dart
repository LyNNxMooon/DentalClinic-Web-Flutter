import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/controller/feed_back_controller.dart';
import 'package:dental_clinic/data/vos/feed_back_vo.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/no_connection_mobile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _feedbackController = Get.put(FeedBackController());

class FeedBackDetailScreen extends StatefulWidget {
  const FeedBackDetailScreen({super.key, required this.feedback});

  final FeedBackVO feedback;

  @override
  State<FeedBackDetailScreen> createState() => _FeedBackDetailScreenState();
}

class _FeedBackDetailScreenState extends State<FeedBackDetailScreen> {
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
              padding: const EdgeInsets.all(30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.arrow_back)),
                        const Text(
                          textAlign: TextAlign.start,
                          "Feedbacks Details",
                          style: mobileTitleStyle,
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 30,
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: kRateColor,
                              ),
                          separatorBuilder: (context, index) => const SizedBox(
                                width: 5,
                              ),
                          itemCount: widget.feedback.rate),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "${widget.feedback.patientName} : ",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ])),
                    const SizedBox(
                      height: 30,
                    ),
                    RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(children: [
                          TextSpan(
                              text: widget.feedback.body,
                              style: const TextStyle(fontSize: 18)),
                        ])),
                    const SizedBox(
                      height: 40,
                    ),
                    Obx(
                      () => LoadingStateWidget(
                          loadingState: _feedbackController.getLoadingState,
                          loadingSuccessWidget: DeleteBtn(
                            function: () {
                              _feedbackController
                                  .deleteFeedback(widget.feedback.id);
                            },
                          ),
                          loadingInitWidget: DeleteBtn(
                            function: () {
                              _feedbackController
                                  .deleteFeedback(widget.feedback.id);
                            },
                          ),
                          paddingTop: 0),
                    )
                  ],
                ),
              ),
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
                        width: 20,
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
                      height: 20,
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

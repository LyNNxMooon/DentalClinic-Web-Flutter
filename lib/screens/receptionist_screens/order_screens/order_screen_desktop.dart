// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/controller/order_controller.dart';
import 'package:dental_clinic/data/vos/order_vo.dart';
import 'package:dental_clinic/widgets/load_fail_widget.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/no_connection_desktop_widget.dart';
import 'package:dental_clinic/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

final _orderController = Get.put(OrderController());

class DesktopOrderScreen extends StatefulWidget {
  const DesktopOrderScreen({super.key});

  @override
  State<DesktopOrderScreen> createState() => _DesktopOrderScreenState();
}

class _DesktopOrderScreenState extends State<DesktopOrderScreen> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  String connection = "online";

  List<OrderVO> allOrders = [];
  List<OrderVO> filteredOrders = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    allOrders = _orderController.orderList;

    searchController.addListener(() {
      filterOrders();
    });
  }

  void filterOrders() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredOrders = allOrders.where((order) {
        return order.patientName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    searchController.dispose();
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
              padding: const EdgeInsets.all(40),
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back)),
                      const Text(
                        textAlign: TextAlign.start,
                        "Pharmacy Orders",
                        style: desktopTitleStyle,
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  CustomTextField(
                      hintText: "Search Orders by Patients' names",
                      label: "Search  🔍",
                      controller: searchController),
                  const Gap(40),
                  Obx(
                    () => LoadingStateWidget(
                      loadingState: _orderController.getLoadingState,
                      loadingSuccessWidget: orderList(context,
                          filteredOrders.isEmpty ? allOrders : filteredOrders),
                      loadingInitWidget: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.2,
                            bottom: MediaQuery.of(context).size.height * 0.2),
                        child: LoadFailWidget(
                          function: () {
                            _orderController.callOrders();
                          },
                        ),
                      ),
                      paddingTop: MediaQuery.of(context).size.height * 0.2,
                      paddingBottom: MediaQuery.of(context).size.height * 0.2,
                    ),
                  ),
                  const Gap(60)
                ],
              ),
            )
          : const NoConnectionDesktopWidget(),
    );
  }

  Widget orderList(BuildContext context, List<OrderVO> orders) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => OrderTile(order: orders[index]),
        separatorBuilder: (context, index) => const Gap(20),
        itemCount: orders.length);
  }
}

class OrderTile extends StatefulWidget {
  const OrderTile({super.key, required this.order});
  final OrderVO order;

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  bool isExpanded = false;

  String? _orderStatus;

  late TextEditingController _feeController;
  late TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() {
        _orderStatus = widget.order.orderStatus;
        _feeController =
            TextEditingController(text: widget.order.deliveryFees.toString());
        _reasonController =
            TextEditingController(text: widget.order.orderRejectReason);
        isExpanded = !isExpanded;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 2, color: kThirdColor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(widget.order.date),
                    RichText(
                        text: TextSpan(children: [
                      const TextSpan(
                          text: "/ Total - ",
                          style: TextStyle(color: kFourthColor)),
                      TextSpan(
                          text: widget.order.totalPrice.toString(),
                          style: const TextStyle(
                              color: kSecondaryColor,
                              fontWeight: FontWeight.bold)),
                      const TextSpan(
                          text: " Ks",
                          style: TextStyle(
                              color: kSecondaryColor,
                              fontWeight: FontWeight.bold)),
                    ])),
                  ],
                ),
                isExpanded
                    ? const Icon(Icons.arrow_drop_up)
                    : const Icon(Icons.arrow_drop_down)
              ],
            ),
            !isExpanded
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(15),
                      Row(
                        children: [
                          const Text("Order Status - ",
                              style: TextStyle(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.bold)),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text(
                                'Pending',
                                style: TextStyle(fontSize: 10),
                              ),
                              value: 'Pending',
                              groupValue: _orderStatus,
                              onChanged: (String? value) {
                                setState(() {
                                  _orderStatus = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Delivered',
                                  style: TextStyle(fontSize: 10)),
                              value: 'Delivered',
                              groupValue: _orderStatus,
                              onChanged: (String? value) {
                                setState(() {
                                  _orderStatus = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Completed',
                                  style: TextStyle(
                                      fontSize: 10, color: kThirdColor)),
                              value: 'Completed',
                              groupValue: _orderStatus,
                              onChanged: null,
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text('Rejected',
                                  style: TextStyle(fontSize: 10)),
                              value: 'Rejected',
                              groupValue: _orderStatus,
                              onChanged: (String? value) {
                                setState(() {
                                  _orderStatus = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      _orderStatus == "Rejected"
                          ? Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: CustomTextField(
                                  hintText:
                                      "Enter a reason to reject this order",
                                  label: "Order Reject Reason",
                                  controller: _reasonController),
                            )
                          : const SizedBox(),
                      const Gap(15),
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Payment Method - ",
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: widget.order.payment,
                            style: const TextStyle(color: kFourthColor)),
                      ])),
                      const Gap(15),
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Order No. - ",
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: widget.order.id.toString(),
                            style: const TextStyle(color: kThirdColor)),
                      ])),
                      const Gap(15),
                      widget.order.slip.isEmpty
                          ? const SizedBox()
                          : Row(
                              children: [
                                const Text("Slip",
                                    style: TextStyle(
                                        color: kSecondaryColor,
                                        fontWeight: FontWeight.bold)),
                                const Gap(10),
                                TextButton(
                                    style: ButtonStyle(
                                        minimumSize: MaterialStateProperty.all(
                                            const Size(60, 20)),
                                        backgroundColor:
                                            const WidgetStatePropertyAll(
                                                kSecondaryColor)),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: SizedBox(
                                              width: 100,
                                              height: 300,
                                              child: Image.network(
                                                widget.order.slip,
                                                fit: BoxFit.contain,
                                              )),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "View",
                                      style: TextStyle(
                                          color: kFourthColor, fontSize: 10),
                                    ))
                              ],
                            ),
                      const Gap(15),
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Patient ID - ",
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: widget.order.patientID,
                            style: const TextStyle(color: kThirdColor)),
                      ])),
                      const Gap(15),
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Patient Name - ",
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: widget.order.patientName,
                            style: const TextStyle(color: kFourthColor)),
                      ])),
                      const Gap(15),
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Patient Phone - ",
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: widget.order.patientPhone.toString(),
                            style: const TextStyle(color: kFourthColor)),
                      ])),
                      const Gap(15),
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Patient Address - ",
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: widget.order.patientAddress,
                            style: const TextStyle(color: kFourthColor)),
                      ])),
                      const Gap(15),
                      const Divider(
                        color: kThirdColor,
                        thickness: 1,
                        indent: 5,
                        endIndent: 5,
                      ),
                      const Gap(15),
                      ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text:
                                        "${widget.order.items[index].name} × ",
                                    style:
                                        const TextStyle(color: kFourthColor)),
                                TextSpan(
                                    text: widget.order.items[index].qty
                                        .toString(),
                                    style: const TextStyle(
                                        color: kFourthColor,
                                        fontWeight: FontWeight.bold)),
                                const TextSpan(
                                    text: " - ",
                                    style: TextStyle(color: kFourthColor)),
                                TextSpan(
                                    text:
                                        "${widget.order.items[index].price.toString()} Ks",
                                    style: const TextStyle(
                                        color: kSecondaryColor,
                                        fontWeight: FontWeight.bold)),
                              ])),
                          separatorBuilder: (context, index) => const Gap(10),
                          itemCount: widget.order.items.length),
                      const Gap(15),
                      const Divider(
                        color: kThirdColor,
                        thickness: 1,
                        indent: 5,
                        endIndent: 5,
                      ),
                      const Gap(15),
                      Row(
                        children: [
                          const Text("Delivery Fees - ",
                              style: TextStyle(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.bold)),
                          const Gap(20),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: _feeController,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                isDense: true,
                              ),
                            ),
                          ),
                          const Gap(10),
                          const Text(" Ks",
                              style: TextStyle(
                                color: kFourthColor,
                              )),
                        ],
                      ),
                      const Gap(15),
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Total + Delivery - ",
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                "${(widget.order.totalPrice + widget.order.deliveryFees).toString()} Ks",
                            style: const TextStyle(color: kFourthColor)),
                      ])),
                      const Gap(15),
                      TextButton(
                          style: const ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(kSecondaryColor),
                              foregroundColor:
                                  WidgetStatePropertyAll(kFourthColor)),
                          onPressed: () {
                            _orderController.updateOrder(
                                context,
                                widget.order.id,
                                widget.order.items,
                                widget.order.totalPrice.toDouble(),
                                _orderStatus ?? "Pending",
                                widget.order.payment,
                                widget.order.slip,
                                widget.order.patientID,
                                widget.order.patientName,
                                widget.order.patientPhone,
                                widget.order.patientAddress,
                                _feeController.text,
                                widget.order.date,
                                _reasonController.text);
                          },
                          child: const Text("Update"))
                    ],
                  )
          ],
        ),
      ),
    );
  }
}

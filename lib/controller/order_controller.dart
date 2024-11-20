// ignore_for_file: use_build_context_synchronously

import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/data/vos/cart_item_vo.dart';
import 'package:dental_clinic/data/vos/order_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:dental_clinic/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class OrderController extends BaseController {
  RxList<OrderVO> orderList = <OrderVO>[].obs;

  final _firebaseService = FirebaseServices();

  @override
  void onInit() {
    callOrders();
    super.onInit();
  }

  callOrders() async {
    setLoadingState = LoadingState.loading;
    _firebaseService.getAllOrdersStream().listen(
      (event) {
        if (event == null || event.isEmpty) {
          setLoadingState = LoadingState.error;
        } else {
          orderList.value = event;
          setLoadingState = LoadingState.complete;
        }
      },
    ).onError((error) {
      setLoadingState = LoadingState.error;
    });

    update();
  }

  Future updateOrder(
      BuildContext context,
      int id,
      List<CartItemVO> items,
      double totalPrice,
      String status,
      String payment,
      String url,
      String patientId,
      String patientName,
      int patientPhone,
      String patientAddress,
      String fees,
      String date,
      String rejectReason) async {
    RegExp letterRegExp = RegExp(r'[a-zA-Z]');
    if (letterRegExp.hasMatch(fees)) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Delivery fees must be numbers!";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
          function: () {
            Get.back();
          },
        ),
      );
    } else if (status == "Rejected" && rejectReason.isEmpty) {
      setLoadingState = LoadingState.error;
      setErrorMessage = "Enter reason to reject this order!";
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CustomErrorWidget(
          errorMessage: getErrorMessage,
          function: () {
            Get.back();
          },
        ),
      );
    } else {
      setLoadingState = LoadingState.loading;

      final orderVo = OrderVO(
          orderRejectReason: status == "Rejected" ? rejectReason : "",
          deliveryFees: fees.isEmpty ? 0.0 : double.parse(fees),
          date: date,
          id: id,
          items: items,
          totalPrice: totalPrice,
          orderStatus: status,
          payment: payment,
          slip: url,
          patientID: patientId,
          patientName: patientName,
          patientPhone: patientPhone,
          patientAddress: patientAddress);
      return _firebaseService.saveOrder(orderVo).then(
        (value) {
          setLoadingState = LoadingState.complete;

          callOrders();

          Fluttertoast.showToast(
              msg: "Order Updated!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: kSuccessColor,
              textColor: kFourthColor,
              fontSize: 20);
        },
      ).catchError((error) {
        setLoadingState = LoadingState.error;
        setErrorMessage = error;
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => CustomErrorWidget(
            errorMessage: getErrorMessage,
            function: () {
              Get.back();
            },
          ),
        );
      });
    }

    update();
  }
}

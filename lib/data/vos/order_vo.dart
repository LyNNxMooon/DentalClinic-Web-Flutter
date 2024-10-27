import 'package:dental_clinic/data/vos/cart_item_vo.dart';
import 'package:json_annotation/json_annotation.dart';
part 'order_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderVO {
  final int id;
  final List<CartItemVO> items;
  @JsonKey(name: 'total_price')
  final num totalPrice;
  @JsonKey(name: 'order_status')
  final String orderStatus;
  final String payment;
  final String slip;
  @JsonKey(name: 'patient_id')
  final String patientID;
  @JsonKey(name: 'patient_name')
  final String patientName;
  @JsonKey(name: 'patient_phone')
  final int patientPhone;
  @JsonKey(name: 'patient_address')
  final String patientAddress;
  final String date;
  @JsonKey(name: 'delivery_fees')
  final num deliveryFees;

  OrderVO(
      {required this.id,
      required this.items,
      required this.totalPrice,
      required this.orderStatus,
      required this.payment,
      required this.slip,
      required this.patientID,
      required this.patientName,
      required this.patientPhone,
      required this.patientAddress,
      required this.date,
      required this.deliveryFees});

  factory OrderVO.fromJson(Map<String, dynamic> json) =>
      _$OrderVOFromJson(json);

  Map<String, dynamic> toJson() => _$OrderVOToJson(this);
}

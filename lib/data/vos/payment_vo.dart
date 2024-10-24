import 'package:json_annotation/json_annotation.dart';
part 'payment_vo.g.dart';

@JsonSerializable()
class PaymentVO {
  final int id;
  final String accountName;
  final String accountNumber;
  final String type;
  final String url;

  PaymentVO(
      {required this.id,
      required this.accountName,
      required this.accountNumber,
      required this.type,
      required this.url});

  factory PaymentVO.fromJson(Map<String, dynamic> json) =>
      _$PaymentVOFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentVOToJson(this);
}

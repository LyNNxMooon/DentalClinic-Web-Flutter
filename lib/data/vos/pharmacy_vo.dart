import 'package:json_annotation/json_annotation.dart';
part 'pharmacy_vo.g.dart';

@JsonSerializable()
class PharmacyVO {
  final int id;
  final String url;
  final String name;
  final double price;
  @JsonKey(name: 'is_out_of_stocks')
  final String isOutOfStock;

  PharmacyVO(
      {required this.id,
      required this.url,
      required this.name,
      required this.price,
      required this.isOutOfStock});

  factory PharmacyVO.fromJson(Map<String, dynamic> json) =>
      _$PharmacyVOFromJson(json);

  Map<String, dynamic> toJson() => _$PharmacyVOToJson(this);
}

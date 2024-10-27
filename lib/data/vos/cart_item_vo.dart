import 'package:json_annotation/json_annotation.dart';
part 'cart_item_vo.g.dart';

@JsonSerializable()
class CartItemVO {
  String name;
  num price;
  @JsonKey(name: 'init_price')
  num initPrice;
  int qty;
  String url;

  CartItemVO(
      {required this.name,
      required this.price,
      required this.initPrice,
      required this.qty,
      required this.url});

  factory CartItemVO.fromJson(Map<String, dynamic> json) =>
      _$CartItemVOFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemVOToJson(this);
}

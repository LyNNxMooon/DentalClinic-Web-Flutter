// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartItemVO _$CartItemVOFromJson(Map<String, dynamic> json) => CartItemVO(
      name: json['name'] as String,
      price: json['price'] as num,
      initPrice: json['init_price'] as num,
      qty: (json['qty'] as num).toInt(),
      url: json['url'] as String,
    );

Map<String, dynamic> _$CartItemVOToJson(CartItemVO instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'init_price': instance.initPrice,
      'qty': instance.qty,
      'url': instance.url,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pharmacy_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PharmacyVO _$PharmacyVOFromJson(Map<String, dynamic> json) => PharmacyVO(
      id: (json['id'] as num).toInt(),
      url: json['url'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$PharmacyVOToJson(PharmacyVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'name': instance.name,
      'price': instance.price,
    };

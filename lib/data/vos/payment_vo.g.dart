// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentVO _$PaymentVOFromJson(Map<String, dynamic> json) => PaymentVO(
      id: (json['id'] as num).toInt(),
      accountName: json['accountName'] as String,
      accountNumber: json['accountNumber'] as String,
      type: json['type'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$PaymentVOToJson(PaymentVO instance) => <String, dynamic>{
      'id': instance.id,
      'accountName': instance.accountName,
      'accountNumber': instance.accountNumber,
      'type': instance.type,
      'url': instance.url,
    };

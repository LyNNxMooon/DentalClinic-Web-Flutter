// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderVO _$OrderVOFromJson(Map<String, dynamic> json) => OrderVO(
      id: (json['id'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemVO.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: json['total_price'] as num,
      orderStatus: json['order_status'] as String,
      payment: json['payment'] as String,
      slip: json['slip'] as String,
      patientID: json['patient_id'] as String,
      patientName: json['patient_name'] as String,
      patientPhone: (json['patient_phone'] as num).toInt(),
      patientAddress: json['patient_address'] as String,
      date: json['date'] as String,
      deliveryFees: json['delivery_fees'] as num,
      orderRejectReason: json['order_reject_reason'] as String,
    );

Map<String, dynamic> _$OrderVOToJson(OrderVO instance) => <String, dynamic>{
      'id': instance.id,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'total_price': instance.totalPrice,
      'order_status': instance.orderStatus,
      'payment': instance.payment,
      'slip': instance.slip,
      'patient_id': instance.patientID,
      'patient_name': instance.patientName,
      'patient_phone': instance.patientPhone,
      'patient_address': instance.patientAddress,
      'date': instance.date,
      'delivery_fees': instance.deliveryFees,
      'order_reject_reason': instance.orderRejectReason,
    };

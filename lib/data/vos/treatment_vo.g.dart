// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatment_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TreatmentVO _$TreatmentVOFromJson(Map<String, dynamic> json) => TreatmentVO(
      id: (json['id'] as num).toInt(),
      doctorID: (json['doctorID'] as num).toInt(),
      doctorName: json['doctorName'] as String,
      patientID: json['patientID'] as String,
      patientName: json['patientName'] as String,
      treatment: json['treatment'] as String,
      dosage: json['dosage'] as String,
      cost: (json['cost'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      date: json['date'] as String,
      time: json['time'] as String,
      paymentStatus: json['payment_status'] as String,
      paymentType: json['payment_type'] as String,
      slip: json['slip'] as String,
    );

Map<String, dynamic> _$TreatmentVOToJson(TreatmentVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctorID': instance.doctorID,
      'doctorName': instance.doctorName,
      'patientID': instance.patientID,
      'patientName': instance.patientName,
      'treatment': instance.treatment,
      'dosage': instance.dosage,
      'cost': instance.cost,
      'discount': instance.discount,
      'date': instance.date,
      'time': instance.time,
      'payment_status': instance.paymentStatus,
      'payment_type': instance.paymentType,
      'slip': instance.slip,
    };

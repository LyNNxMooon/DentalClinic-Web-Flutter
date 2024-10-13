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
      date: json['date'] as String,
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
      'date': instance.date,
    };

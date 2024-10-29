// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentVO _$AppointmentVOFromJson(Map<String, dynamic> json) =>
    AppointmentVO(
      id: (json['id'] as num).toInt(),
      doctorId: (json['doctor_id'] as num).toInt(),
      doctorName: json['doctor_name'] as String,
      patientId: json['patient_id'] as String,
      patientName: json['patient_name'] as String,
      patientPhone: (json['patient_phone'] as num).toInt(),
      date: json['date'] as String,
      time: json['time'] as String,
    );

Map<String, dynamic> _$AppointmentVOToJson(AppointmentVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'doctor_id': instance.doctorId,
      'doctor_name': instance.doctorName,
      'patient_id': instance.patientId,
      'patient_name': instance.patientName,
      'patient_phone': instance.patientPhone,
      'date': instance.date,
      'time': instance.time,
    };

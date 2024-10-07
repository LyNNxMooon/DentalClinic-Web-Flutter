// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientVO _$PatientVOFromJson(Map<String, dynamic> json) => PatientVO(
      id: json['id'] as String,
      name: json['name'] as String,
      url: json['url'] as String,
      age: (json['age'] as num).toInt(),
      gender: json['gender'] as String,
    );

Map<String, dynamic> _$PatientVOToJson(PatientVO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'age': instance.age,
      'gender': instance.gender,
    };

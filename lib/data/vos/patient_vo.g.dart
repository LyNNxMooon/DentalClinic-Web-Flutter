// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientVO _$PatientVOFromJson(Map<String, dynamic> json) => PatientVO(
    id: json['id'] as String,
    name: json['name'] as String,
    phone: (json['phone'] as num).toInt(),
    address: json['address'] as String,
    allergicMedicine: json['allergic_medicine'] as String,
    isBanned: json['is_banned'] as bool,
    url: json['url'] as String,
    age: (json['age'] as num).toInt(),
    gender: json['gender'] as String,
    banReason: json['ban_reason'] as String);

Map<String, dynamic> _$PatientVOToJson(PatientVO instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'address': instance.address,
      'allergic_medicine': instance.allergicMedicine,
      'is_banned': instance.isBanned,
      'url': instance.url,
      'age': instance.age,
      'gender': instance.gender,
      'ban_reason': instance.banReason
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorVO _$DoctorVOFromJson(Map<String, dynamic> json) => DoctorVO(
      id: (json['id'] as num).toInt(),
      url: json['url'] as String,
      name: json['name'] as String,
      bio: json['bio'] as String,
      specialist: json['specialist'] as String,
      experience: json['experience'] as String,
      dayOff: json['day_off'] as String,
    );

Map<String, dynamic> _$DoctorVOToJson(DoctorVO instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'name': instance.name,
      'bio': instance.bio,
      'specialist': instance.specialist,
      'experience': instance.experience,
      'day_off': instance.dayOff,
    };

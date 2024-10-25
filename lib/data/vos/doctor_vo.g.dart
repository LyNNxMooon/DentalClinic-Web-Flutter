// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorVO _$DoctorVOFromJson(Map<String, dynamic> json) => DoctorVO(
      id: (json['id'] as num).toInt(),
      url: json['url'] as String,
      name: json['name'] as String,
      doctorID: json['doctor_id'] as String,
      bio: json['bio'] as String,
      specialist: json['specialist'] as String,
      experience: json['experience'] as String,
      availability: json['availability'],
    );

Map<String, dynamic> _$DoctorVOToJson(DoctorVO instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'name': instance.name,
      'doctor_id': instance.doctorID,
      'bio': instance.bio,
      'specialist': instance.specialist,
      'experience': instance.experience,
      'availability': instance.availability,
    };

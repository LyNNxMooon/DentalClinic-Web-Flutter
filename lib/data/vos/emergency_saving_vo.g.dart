// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_saving_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmergencySavingVO _$EmergencySavingVOFromJson(Map<String, dynamic> json) =>
    EmergencySavingVO(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      url: json['url'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$EmergencySavingVOToJson(EmergencySavingVO instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'url': instance.url,
      'body': instance.body,
    };

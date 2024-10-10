// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_back_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedBackVO _$FeedBackVOFromJson(Map<String, dynamic> json) => FeedBackVO(
      body: json['body'] as String,
      id: (json['id'] as num).toInt(),
      patientID: json['patient_id'] as String,
      display: json['display'] as bool,
      patientName: json['patient_name'] as String,
      rate: (json['rate'] as num).toInt(),
    );

Map<String, dynamic> _$FeedBackVOToJson(FeedBackVO instance) =>
    <String, dynamic>{
      'body': instance.body,
      'id': instance.id,
      'patient_id': instance.patientID,
      'patient_name': instance.patientName,
      'display': instance.display,
      'rate': instance.rate,
    };

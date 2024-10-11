// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatted_user_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChattedUserVO _$ChattedUserVOFromJson(Map<String, dynamic> json) =>
    ChattedUserVO(
      chattedUserName: json['name'] as String,
      chattedUserID: json['chatted_user_uid'] as String,
      lastSenderID: json['last_sender_uid'] as String,
      profileURL: json['profile_url'] as String,
      lastMessage: json['last_message'] as String,
      dateTime: json['date_time'] as String,
    );

Map<String, dynamic> _$ChattedUserVOToJson(ChattedUserVO instance) =>
    <String, dynamic>{
      'name': instance.chattedUserName,
      'chatted_user_uid': instance.chattedUserID,
      'last_sender_uid': instance.lastSenderID,
      'profile_url': instance.profileURL,
      'last_message': instance.lastMessage,
      'date_time': instance.dateTime,
    };

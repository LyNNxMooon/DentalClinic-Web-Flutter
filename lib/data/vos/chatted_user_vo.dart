import 'package:json_annotation/json_annotation.dart';
part 'chatted_user_vo.g.dart';

@JsonSerializable()
class ChattedUserVO {
  @JsonKey(name: 'name')
  String chattedUserName;

  @JsonKey(name: 'chatted_user_uid')
  String chattedUserID;

  @JsonKey(name: 'last_sender_uid')
  String lastSenderID;

  @JsonKey(name: 'profile_url')
  String profileURL;

  @JsonKey(name: 'last_message')
  String lastMessage;

  @JsonKey(name: 'date_time')
  String dateTime;

  ChattedUserVO(
      {required this.chattedUserName,
      required this.chattedUserID,
      required this.lastSenderID,
      required this.profileURL,
      required this.lastMessage,
      required this.dateTime});

  factory ChattedUserVO.fromJson(Map<String, dynamic> json) =>
      _$ChattedUserVOFromJson(json);

  Map<String, dynamic> toJson() => _$ChattedUserVOToJson(this);
}

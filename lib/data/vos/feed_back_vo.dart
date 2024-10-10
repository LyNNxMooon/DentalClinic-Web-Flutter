import 'package:json_annotation/json_annotation.dart';
part 'feed_back_vo.g.dart';

@JsonSerializable()
class FeedBackVO {
  final String body;
  final int id;
  @JsonKey(name: 'patient_id')
  final String patientID;
  @JsonKey(name: 'patient_name')
  final String patientName;
  final bool display;
  final int rate;

  FeedBackVO(
      {required this.body,
      required this.id,
      required this.patientID,
      required this.display,
      required this.patientName,
      required this.rate});

  factory FeedBackVO.fromJson(Map<String, dynamic> json) =>
      _$FeedBackVOFromJson(json);

  Map<String, dynamic> toJson() => _$FeedBackVOToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
part 'emergency_saving_vo.g.dart';

@JsonSerializable()
class EmergencySavingVO {
  final int id;
  final String title;
  final String url;
  final String body;

  EmergencySavingVO(
      {required this.id,
      required this.title,
      required this.url,
      required this.body});

  factory EmergencySavingVO.fromJson(Map<String, dynamic> json) =>
      _$EmergencySavingVOFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencySavingVOToJson(this);
}

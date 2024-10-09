import 'package:json_annotation/json_annotation.dart';
part 'patient_vo.g.dart';

@JsonSerializable()
class PatientVO {
  final String id;
  final String name;
  @JsonKey(name: "is_banned")
  final bool isBanned;
  final String url;
  final int age;
  final String gender;

  PatientVO(
      {required this.id,
      required this.name,
      required this.isBanned,
      required this.url,
      required this.age,
      required this.gender});

  factory PatientVO.fromJson(Map<String, dynamic> json) =>
      _$PatientVOFromJson(json);

  Map<String, dynamic> toJson() => _$PatientVOToJson(this);
}

import 'package:json_annotation/json_annotation.dart';
part 'doctor_vo.g.dart';

@JsonSerializable()
class DoctorVO {
  final int id;
  final String url;
  final String name;
  final String bio;
  final String specialist;
  final String experience;
  @JsonKey(name: "day_off")
  final String dayOff;

  DoctorVO(
      {required this.id,
      required this.url,
      required this.name,
      required this.bio,
      required this.specialist,
      required this.experience,
      required this.dayOff});

  factory DoctorVO.fromJson(Map<String, dynamic> json) =>
      _$DoctorVOFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorVOToJson(this);
}

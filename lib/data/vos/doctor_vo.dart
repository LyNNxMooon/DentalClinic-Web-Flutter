import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class DoctorVO {
  final int id;
  final String name;
  final String bio;
  final String specialist;
  final String experience;
  @JsonKey(name: "day_off")
  final String dayOff;

  DoctorVO(
      {required this.id,
      required this.name,
      required this.bio,
      required this.specialist,
      required this.experience,
      required this.dayOff});
}

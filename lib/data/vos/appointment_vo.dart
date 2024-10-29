import 'package:json_annotation/json_annotation.dart';

part 'appointment_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointmentVO {
  final int id;
  @JsonKey(name: 'doctor_id')
  final int doctorId;
  @JsonKey(name: 'doctor_name')
  final String doctorName;
  @JsonKey(name: 'patient_id')
  final String patientId;
  @JsonKey(name: 'patient_name')
  final String patientName;
  @JsonKey(name: 'patient_phone')
  final int patientPhone;
  final String date;
  final String time;

  // Updated fromJson to handle nested deserialization

  AppointmentVO(
      {required this.id,
      required this.doctorId,
      required this.doctorName,
      required this.patientId,
      required this.patientName,
      required this.patientPhone,
      required this.date,
      required this.time});

  factory AppointmentVO.fromJson(Map<String, dynamic> json) =>
      _$AppointmentVOFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentVOToJson(this);
}

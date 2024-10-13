import 'package:json_annotation/json_annotation.dart';
part 'treatment_vo.g.dart';

@JsonSerializable()
class TreatmentVO {
  final int id;
  final int doctorID;
  final String doctorName;
  final String patientID;
  final String patientName;
  final String treatment;
  final String dosage;
  final String date;

  TreatmentVO(
      {required this.id,
      required this.doctorID,
      required this.doctorName,
      required this.patientID,
      required this.patientName,
      required this.treatment,
      required this.dosage,
      required this.date});

  factory TreatmentVO.fromJson(Map<String, dynamic> json) =>
      _$TreatmentVOFromJson(json);

  Map<String, dynamic> toJson() => _$TreatmentVOToJson(this);
}

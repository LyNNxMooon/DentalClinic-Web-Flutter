import 'package:json_annotation/json_annotation.dart';
part 'treatment_vo.g.dart';

@JsonSerializable()
class TreatmentVO {
  final int id;
  @JsonKey(name: 'doctor_id')
  final int doctorID;
  @JsonKey(name: 'doctor_name')
  final String doctorName;
  @JsonKey(name: 'patient_id')
  final String patientID;
  @JsonKey(name: 'patient_name')
  final String patientName;
  final String treatment;
  final String dosage;
  final double cost;
  final double discount;
  final String date;
  final String time;
  @JsonKey(name: "payment_status")
  final String paymentStatus;
  @JsonKey(name: "payment_type")
  final String paymentType;
  final String slip;

  TreatmentVO(
      {required this.id,
      required this.doctorID,
      required this.doctorName,
      required this.patientID,
      required this.patientName,
      required this.treatment,
      required this.dosage,
      required this.cost,
      required this.discount,
      required this.date,
      required this.time,
      required this.paymentStatus,
      required this.paymentType,
      required this.slip});

  factory TreatmentVO.fromJson(Map<String, dynamic> json) =>
      _$TreatmentVOFromJson(json);

  Map<String, dynamic> toJson() => _$TreatmentVOToJson(this);
}

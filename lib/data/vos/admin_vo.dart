import 'package:json_annotation/json_annotation.dart';
part 'admin_vo.g.dart';

@JsonSerializable()
class AdminVO {
  final String id;

  AdminVO({required this.id});

  factory AdminVO.fromJson(Map<String, dynamic> json) =>
      _$AdminVOFromJson(json);

  Map<String, dynamic> toJson() => _$AdminVOToJson(this);
}

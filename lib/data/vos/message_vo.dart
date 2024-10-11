import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MessageVO {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timeStamp;

  MessageVO(
      {required this.senderID,
      required this.senderEmail,
      required this.receiverID,
      required this.message,
      required this.timeStamp});

  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderID,
      'sender_email': senderEmail,
      'receiver_id': receiverID,
      'message': message,
      'time_stamp': timeStamp
    };
  }
}

import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MessageVO {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final DateTime timeStamp; // Changed from Firestore Timestamp to DateTime

  MessageVO({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.message,
    required this.timeStamp,
  });

  // Convert MessageVO object to a Map (for Firebase Realtime Database)
  Map<String, dynamic> toJson() {
    return {
      'sender_id': senderID,
      'sender_email': senderEmail,
      'receiver_id': receiverID,
      'message': message,
      'time_stamp': timeStamp.millisecondsSinceEpoch, // Store timestamp as int
    };
  }

  // Factory constructor to create a MessageVO from a Map (for reading from Realtime Database)
  factory MessageVO.fromJson(Map<String, dynamic> json) {
    return MessageVO(
      senderID: json['sender_id'] as String,
      senderEmail: json['sender_email'] as String,
      receiverID: json['receiver_id'] as String,
      message: json['message'] as String,
      timeStamp: DateTime.fromMillisecondsSinceEpoch(json['time_stamp'] as int),
    );
  }
}

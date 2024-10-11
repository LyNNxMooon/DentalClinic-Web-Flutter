import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/firebase/firebase.dart';

class ChatController extends BaseController {
  final _firebaseService = FirebaseServices();

  Future<void> sendMessages(String receiverID, String message,
          String receiverName, String receiverProfile) =>
      _firebaseService.sendMessages(
          receiverID, message, receiverName, receiverProfile);

  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) =>
      _firebaseService.getMessages(userID, otherUserID);
}

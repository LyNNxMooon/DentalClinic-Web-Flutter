// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:typed_data';

import 'package:dental_clinic/data/vos/appointment_vo.dart';
import 'package:dental_clinic/data/vos/chatted_user_vo.dart';
import 'package:dental_clinic/data/vos/doctor_vo.dart';
import 'package:dental_clinic/data/vos/emergency_saving_vo.dart';
import 'package:dental_clinic/data/vos/feed_back_vo.dart';
import 'package:dental_clinic/data/vos/message_vo.dart';
import 'package:dental_clinic/data/vos/patient_vo.dart';
import 'package:dental_clinic/data/vos/payment_vo.dart';
import 'package:dental_clinic/data/vos/pharmacy_vo.dart';
import 'package:dental_clinic/data/vos/treatment_vo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  FirebaseServices._();
  static final FirebaseServices _singleton = FirebaseServices._();
  factory FirebaseServices() => _singleton;

  //Auth
  Future firebaseSignIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      return Future.error(error);
    }
  }

  Future firebaseSignUp(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      return Future.error(error);
    }
  }

  //Realtime database
  final databaseRef = FirebaseDatabase.instance.ref();

  Future saveDoctor(DoctorVO doctorVo) async {
    try {
      return databaseRef
          .child("doctors")
          .child(doctorVo.id.toString())
          .set(doctorVo.toJson());
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Future saveAppointment(AppointmentVO appointmentVo) async {
    try {
      return databaseRef
          .child("appointments")
          .child(appointmentVo.id.toString())
          .set(appointmentVo.toJson());
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Stream<List<AppointmentVO>?> getAppointmentListStream() {
    return databaseRef.child("appointments").onValue.map((event) {
      return event.snapshot.children.map<AppointmentVO>((snapshot) {
        return AppointmentVO.fromJson(
            Map<String, dynamic>.from(snapshot.value as Map));
      }).toList();
    });
  }

  Future deleteAppointment(int id) async {
    try {
      return databaseRef.child("appointments").child(id.toString()).remove();
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Future savePatient(PatientVO patientVo) async {
    try {
      return databaseRef
          .child("patients")
          .child(patientVo.id.toString())
          .set(patientVo.toJson());
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Future deletePatient(String id) async {
    try {
      return databaseRef.child("patients").child(id.toString()).remove();
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Stream<List<PatientVO>?> getPatientListStream() {
    return databaseRef.child("patients").onValue.map((event) {
      return event.snapshot.children.map<PatientVO>((snapshot) {
        return PatientVO.fromJson(
            Map<String, dynamic>.from(snapshot.value as Map));
      }).toList();
    });
  }

  Stream<List<DoctorVO>?> getDoctorListStream() {
    return databaseRef.child("doctors").onValue.map((event) {
      return event.snapshot.children.map<DoctorVO>((snapshot) {
        return DoctorVO.fromJson(
            Map<String, dynamic>.from(snapshot.value as Map));
      }).toList();
    });
  }

  Future deleteDoctor(int id) async {
    try {
      return databaseRef.child("doctors").child(id.toString()).remove();
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Future saveEmergencySaving(EmergencySavingVO savingVo) async {
    try {
      return databaseRef
          .child("emergency")
          .child(savingVo.id.toString())
          .set(savingVo.toJson());
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Future saveTreatment(TreatmentVO treatmentVo) async {
    try {
      return databaseRef
          .child("treatments")
          .child(treatmentVo.id.toString())
          .set(treatmentVo.toJson());
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Stream<List<TreatmentVO>?> getTreatmentListStream() {
    return databaseRef.child("treatments").onValue.map((event) {
      return event.snapshot.children.map<TreatmentVO>((snapshot) {
        return TreatmentVO.fromJson(
            Map<String, dynamic>.from(snapshot.value as Map));
      }).toList();
    });
  }

  Future deleteTreatment(int id) async {
    try {
      return databaseRef.child("treatments").child(id.toString()).remove();
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Future savePayment(PaymentVO paymentVo) async {
    try {
      return databaseRef
          .child("payments")
          .child(paymentVo.id.toString())
          .set(paymentVo.toJson());
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Stream<List<PaymentVO>?> getPaymentListStream() {
    return databaseRef.child("payments").onValue.map((event) {
      return event.snapshot.children.map<PaymentVO>((snapshot) {
        return PaymentVO.fromJson(
            Map<String, dynamic>.from(snapshot.value as Map));
      }).toList();
    });
  }

  Future deletePayment(int id) async {
    try {
      return databaseRef.child("payments").child(id.toString()).remove();
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Stream<List<EmergencySavingVO>?> getEmergencySavingListStream() {
    return databaseRef.child("emergency").onValue.map((event) {
      return event.snapshot.children.map<EmergencySavingVO>((snapshot) {
        return EmergencySavingVO.fromJson(
            Map<String, dynamic>.from(snapshot.value as Map));
      }).toList();
    });
  }

  Stream<List<FeedBackVO>?> getFeedBackListStream() {
    return databaseRef.child("patient_feedbacks").onValue.map((event) {
      return event.snapshot.children.map<FeedBackVO>((snapshot) {
        return FeedBackVO.fromJson(
            Map<String, dynamic>.from(snapshot.value as Map));
      }).toList();
    });
  }

  Future saveFeedback(FeedBackVO feedbackVo) async {
    try {
      return databaseRef
          .child("patient_feedbacks")
          .child(feedbackVo.id.toString())
          .set(feedbackVo.toJson());
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Future deleteFeedback(int id) async {
    try {
      return databaseRef
          .child("patient_feedbacks")
          .child(id.toString())
          .remove();
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Future deleteEmergencySaving(int id) async {
    try {
      return databaseRef.child("emergency").child(id.toString()).remove();
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Future<PatientVO?> getPatient(String id) async {
    return databaseRef.child("patients").child(id).once().then((event) {
      if (event.snapshot.value == null) {
        return null;
      } else {
        final rawData = event.snapshot.value;
        return PatientVO.fromJson(Map<String, dynamic>.from(rawData as Map));
      }
    });
  }

  Future savePharmacy(PharmacyVO pharmacyVo) async {
    try {
      return databaseRef
          .child("pharmacy")
          .child(pharmacyVo.id.toString())
          .set(pharmacyVo.toJson());
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Stream<List<PharmacyVO>?> getPharmacyListStream() {
    return databaseRef.child("pharmacy").onValue.map((event) {
      return event.snapshot.children.map<PharmacyVO>((snapshot) {
        return PharmacyVO.fromJson(
            Map<String, dynamic>.from(snapshot.value as Map));
      }).toList();
    });
  }

  Future deletePharmacy(int id) async {
    try {
      return databaseRef.child("pharmacy").child(id.toString()).remove();
    } on FirebaseException catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  //firebase file storage

  static final _firebaseStorage = FirebaseStorage.instance;

  static Future<String> uploadToFirebaseStorage(
      Uint8List file, String path, String contentType) {
    var metadata = SettableMetadata(contentType: contentType);
    return _firebaseStorage
        .ref(path)
        .child(DateTime.now().millisecondsSinceEpoch.toString())
        .putData(file, metadata)
        .then((takeSnapShot) {
      return takeSnapShot.ref.getDownloadURL().then((value) {
        return value;
      });
    });
  }

  //chat services

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
  Future<void> sendMessages(String receiverID, String message,
      String receiverName, String receiverProfile) async {
    final String currentUserID = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final DateTime timeStamp = DateTime.now();

    MessageVO newMessage = MessageVO(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timeStamp: timeStamp);

    //Chat Room
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join("_");

    // Add Message and receiver to Chat Room
    await _firebaseDatabase
        .ref('chat_rooms/$chatRoomID/messages')
        .push()
        .set(newMessage.toJson());

    await _firebaseDatabase.ref('users/$currentUserID/chats/$receiverID').set({
      'name': receiverName,
      'chatted_user_uid': receiverID,
      'last_sender_uid': currentUserID,
      'profile_url': receiverProfile,
      'last_message': message,
      'date_time': timeStamp.toIso8601String(),
    });

    await _firebaseDatabase.ref('users/$receiverID/chats/$currentUserID').set({
      'name': "Admin",
      'chatted_user_uid': currentUserID,
      'last_sender_uid': currentUserID,
      'profile_url':
          "https://www.shutterstock.com/image-vector/user-icon-vector-600nw-393536320.jpg",
      'last_message': message,
      'date_time': timeStamp.toIso8601String(),
    });
  }

  Stream<DatabaseEvent> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join("_");

    // Return a stream from Realtime Database reference for the messages
    return _firebaseDatabase
        .ref('chat_rooms/$chatRoomID/messages')
        .orderByChild('time_stamp') // Ordering by timestamp
        .onValue; // This listens to any changes in the data
  }

  Stream<List<ChattedUserVO>?> getChatListStream() {
    final String currentUserID = _firebaseAuth.currentUser!.uid;

    return _firebaseDatabase
        .ref('users/$currentUserID/chats')
        .orderByChild('date_time') // Order by 'date_time'
        .onValue // Listen to changes in the 'chats' node
        .map((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        return data.values.map((e) {
          return ChattedUserVO.fromJson(Map<String, dynamic>.from(e));
        }).toList();
      } else {
        return null; // Return null if there's no data
      }
    });
  }
}

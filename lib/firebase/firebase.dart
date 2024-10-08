// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:typed_data';

import 'package:dental_clinic/data/vos/appointment_vo.dart';
import 'package:dental_clinic/data/vos/doctor_vo.dart';
import 'package:dental_clinic/data/vos/emergency_saving_vo.dart';
import 'package:dental_clinic/data/vos/feed_back_vo.dart';
import 'package:dental_clinic/data/vos/patient_vo.dart';
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
          .child("patient_feedbacks")
          .child(savingVo.id.toString())
          .set(savingVo.toJson());
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
}

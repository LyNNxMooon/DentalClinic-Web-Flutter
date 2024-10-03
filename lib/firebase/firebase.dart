// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:dental_clinic/data/vos/doctor_vo.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseServices {
  FirebaseServices._();
  static final FirebaseServices _singleton = FirebaseServices._();
  factory FirebaseServices() => _singleton;

  //Realtime database
  final databaseRef = FirebaseDatabase.instance.ref();

  Future saveDoctor(DoctorVO doctorVo) async {
    try {
      return databaseRef
          .child("doctors")
          .child(doctorVo.id.toString())
          .set(doctorVo.toJson());
    } on Exception catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  Stream<List<DoctorVO>?> getDoctorListStream() {
    return databaseRef.child("doctors").onValue.map((event) {
      return event.snapshot.children.map<DoctorVO>((snapshot) {
        return DoctorVO.fromJson(
            Map<String, dynamic>.from(snapshot.value as Map));
      }).toList();
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

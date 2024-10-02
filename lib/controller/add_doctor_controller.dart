import 'dart:io';

import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/data/vos/doctor_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';

class AddDoctorController extends BaseController {
  File? selectFile;

  final _firebaseService = FirebaseServices();

  Future addDoctor(String name, String bio, String specialist,
      String experience, String dayOff) async {
    int id = DateTime.now().millisecondsSinceEpoch;

    String fileURL = await _uploadFileToFirebaseStorage();

    final doctor = DoctorVO(
        id: id,
        url: fileURL,
        name: name,
        bio: bio,
        specialist: specialist,
        experience: experience,
        dayOff: dayOff);
    return _firebaseService.saveDoctor(doctor);
  }

  Future _uploadFileToFirebaseStorage() {
    String path = 'image';
    String contentType = 'image/jpg';

    return FirebaseServices.uploadToFirebaseStorage(
        selectFile!, path, contentType);
  }
}

import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/data/vos/doctor_vo.dart';

import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:get/get.dart';

class ReceptionistHomeController extends BaseController {
  RxList<DoctorVO> doctorsList = <DoctorVO>[].obs;

  final _firebaseService = FirebaseServices();

  @override
  void onInit() {
    callDoctors();

    super.onInit();
  }

  callDoctors() async {
    setLoadingState = LoadingState.loading;
    _firebaseService.getDoctorListStream().listen(
      (event) {
        if (event == null || event.isEmpty) {
          setLoadingState = LoadingState.error;
        } else {
          doctorsList.value = event;
          setLoadingState = LoadingState.complete;
          print(doctorsList[0].availability);
          print(doctorsList[0].url);
        }
      },
    ).onError((error) {
      setLoadingState = LoadingState.error;
    });

    update();
  }
}

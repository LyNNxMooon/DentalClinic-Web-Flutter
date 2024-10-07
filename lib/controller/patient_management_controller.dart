import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/data/vos/patient_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:get/get.dart';

class PatientManagementController extends BaseController {
  RxList<PatientVO> patientList = <PatientVO>[].obs;

  final _firebaseService = FirebaseServices();

  @override
  void onInit() {
    callPatients();
    super.onInit();
  }

  callPatients() async {
    setLoadingState = LoadingState.loading;
    _firebaseService.getPatientListStream().listen(
      (event) {
        if (event == null || event.isEmpty) {
          setLoadingState = LoadingState.error;
        } else {
          patientList.value = event;
          setLoadingState = LoadingState.complete;
        }
      },
    ).onError((error) {
      setLoadingState = LoadingState.error;
    });
  }
}

import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/data/vos/emergency_saving_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:get/get.dart';

class EmergencySavingController extends BaseController {
  RxList<EmergencySavingVO> emergencySavingList = <EmergencySavingVO>[].obs;

  final _firebaseService = FirebaseServices();

  @override
  void onInit() {
    callEmergencySavings();
    super.onInit();
  }

  callEmergencySavings() async {
    setLoadingState = LoadingState.loading;
    _firebaseService.getEmergencySavingListStream().listen(
      (event) {
        if (event == null || event.isEmpty) {
          setLoadingState = LoadingState.error;
        } else {
          emergencySavingList.value = event;
          setLoadingState = LoadingState.complete;
        }
      },
    ).onError((error) {
      setLoadingState = LoadingState.error;
    });
  }
}

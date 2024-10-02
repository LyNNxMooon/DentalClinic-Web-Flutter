import 'package:get/get.dart';
import 'package:dental_clinic/utils/enums.dart';

class BaseController extends GetxController {
  final Rx<LoadingState> _loadingState = LoadingState.init.obs;
  final RxString _errorMessage = "".obs;

  LoadingState get getLoadingState => _loadingState.value;
  String get getErrorMessage => _errorMessage.value;

  set setLoadingState(LoadingState loadingState) =>
      _loadingState.value = loadingState;

  set setErrorMessage(String message) => _errorMessage.value = message;
}

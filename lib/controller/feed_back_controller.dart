import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/data/vos/feed_back_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class FeedBackController extends BaseController {
  RxList<FeedBackVO> feedbackList = <FeedBackVO>[].obs;
  RxList<FeedBackVO> displayFeedback = <FeedBackVO>[].obs;
  final _firebaseService = FirebaseServices();

  @override
  void onInit() {
    callFeedBacks();
    super.onInit();
  }

  callFeedBacks() async {
    displayFeedback.clear();
    setLoadingState = LoadingState.loading;
    _firebaseService.getFeedBackListStream().listen(
      (event) {
        if (event == null || event.isEmpty) {
          setLoadingState = LoadingState.error;
        } else {
          feedbackList.value = event;
          for (FeedBackVO feedback in feedbackList) {
            if (feedback.display) {
              displayFeedback.add(feedback);
            }
          }
          setLoadingState = LoadingState.complete;
        }
      },
    ).onError((error) {
      setLoadingState = LoadingState.error;
    });
  }

  Future chooseFeedback(int id, String body, String patientID,
      String patientName, bool display, int rate) async {
    setLoadingState = LoadingState.loading;

    final feedBack = FeedBackVO(
        body: body,
        id: id,
        patientID: patientID,
        display: display,
        patientName: patientName,
        rate: rate);

    return _firebaseService.saveFeedback(feedBack).then(
      (value) {
        setLoadingState = LoadingState.complete;
        Fluttertoast.showToast(
            msg: "Display feedback Updated!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: kSuccessColor,
            textColor: kFourthColor,
            fontSize: 20);

        callFeedBacks();
      },
    ).catchError((error) {
      print(error);
      setLoadingState = LoadingState.error;
      setErrorMessage = error;
      Fluttertoast.showToast(
          msg: getErrorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: kErrorColor,
          textColor: kPrimaryColor,
          fontSize: 20);
    });
  }

  Future deleteFeedback(int id) async {
    setLoadingState = LoadingState.loading;
    return _firebaseService.deleteFeedback(id).then(
      (value) {
        setLoadingState = LoadingState.complete;
        Fluttertoast.showToast(
            msg: "Feedback Deleted!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: kSuccessColor,
            textColor: kFourthColor,
            fontSize: 20);
        Get.back();
        Get.back();
        callFeedBacks();
      },
    ).catchError((error) {
      setLoadingState = LoadingState.error;
      setErrorMessage = error;
      Fluttertoast.showToast(
          msg: getErrorMessage,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: kErrorColor,
          textColor: kPrimaryColor,
          fontSize: 20);
    });
  }
}

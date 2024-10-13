import 'package:dental_clinic/controller/base_controller.dart';
import 'package:dental_clinic/data/vos/chatted_user_vo.dart';
import 'package:dental_clinic/firebase/firebase.dart';
import 'package:dental_clinic/utils/enums.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class ChatController extends BaseController {
  final _firebaseService = FirebaseServices();

  RxList<ChattedUserVO> chattedUsers = <ChattedUserVO>[].obs;

  @override
  void onInit() {
    callChattedUsers();
    super.onInit();
  }

  Future<void> sendMessages(String receiverID, String message,
          String receiverName, String receiverProfile) =>
      _firebaseService.sendMessages(
          receiverID, message, receiverName, receiverProfile);

  Stream<DatabaseEvent> getMessages(String userID, String otherUserID) =>
      _firebaseService.getMessages(userID, otherUserID);

  callChattedUsers() async {
    setLoadingState = LoadingState.loading;
    _firebaseService.getChatListStream().listen(
      (event) {
        if (event == null || event.isEmpty) {
          setLoadingState = LoadingState.error;
        } else {
          chattedUsers.value = event;
          setLoadingState = LoadingState.complete;
        }
      },
    ).onError((error) {
      setLoadingState = LoadingState.error;
    });

    update();
  }
}

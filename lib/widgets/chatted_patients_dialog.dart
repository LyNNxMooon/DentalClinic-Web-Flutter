import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/controller/chat_controller.dart';
import 'package:dental_clinic/data/vos/chatted_user_vo.dart';
import 'package:dental_clinic/data/vos/message_vo.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _chatController = Get.put(ChatController());

class ChattedPatientsDialog extends StatelessWidget {
  const ChattedPatientsDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text(
                "Chats",
                style: mobileTitleStyle,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(
              () => LoadingStateWidget(
                  loadingState: _chatController.getLoadingState,
                  loadingSuccessWidget: SizedBox(
                    width: 300,
                    height: 400,
                    child: ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => LayoutBuilder(
                                          builder: (context, constraints) {
                                            if (constraints.maxWidth < 600) {
                                              return MobileChatDialog(
                                                patientId: _chatController
                                                    .chattedUsers[index]
                                                    .chattedUserID,
                                                patientName: _chatController
                                                    .chattedUsers[index]
                                                    .chattedUserName,
                                                url: _chatController
                                                    .chattedUsers[index]
                                                    .profileURL,
                                              );
                                            } else {
                                              return ChatDialog(
                                                patientId: _chatController
                                                    .chattedUsers[index]
                                                    .chattedUserID,
                                                patientName: _chatController
                                                    .chattedUsers[index]
                                                    .chattedUserName,
                                                url: _chatController
                                                    .chattedUsers[index]
                                                    .profileURL,
                                              );
                                            }
                                          },
                                        ));
                              },
                              child: ChatTile(
                                  patient: _chatController.chattedUsers[index]),
                            ),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 15,
                            ),
                        itemCount: _chatController.chattedUsers.length),
                  ),
                  loadingInitWidget: const Center(
                    child: Text(
                      "No Chats History",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  paddingTop: 0),
            )
          ],
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.patient});

  final ChattedUserVO patient;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      height: 50,
      decoration: BoxDecoration(
          color: kMessageBubbleColor, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 0.3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    patient.profileURL,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                  width: 60,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [Text(patient.chattedUserName)],
                    ),
                  ))
            ],
          ),
          patient.lastSenderID == FirebaseAuth.instance.currentUser?.uid
              ? const SizedBox()
              : Row(
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                          color: kErrorColor,
                          borderRadius: BorderRadius.circular(3)),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Reply?",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                )
        ],
      ),
    );
  }
}

class ChatDialog extends StatefulWidget {
  const ChatDialog(
      {super.key,
      required this.patientId,
      required this.patientName,
      required this.url});

  final String patientId;
  final String patientName;
  final String url;

  @override
  State<ChatDialog> createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Discussion",
              style: TextStyle(
                  color: kSecondaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: _chatController.getMessages(
                  FirebaseAuth.instance.currentUser!.uid, widget.patientId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Cannot load messages"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: LoadingWidget(),
                  );
                }

                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  Map<dynamic, dynamic> messagesMap =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  List<MessageVO> messages = messagesMap.values.map((message) {
                    return MessageVO.fromJson(
                        Map<String, dynamic>.from(message));
                  }).toList();

                  // Sort the messages by timeStamp in ascending order
                  messages.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

                  messages = messages.reversed.toList();

                  return SizedBox(
                    height: 400,
                    child: ListView(
                      reverse: true,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      // Removed reverse: true to fix the ordering
                      children: messages
                          .map((message) => MessageItemView(message: message))
                          .toList(),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("No messages yet"),
                  );
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 300,
                  height: 60,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(25)),
                  child: TextField(
                    controller: _messageController,
                    cursorRadius: const Radius.circular(25),
                    decoration: InputDecoration(
                      hintText: "Send Message",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: IconButton(
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          _chatController
                              .sendMessages(
                                  widget.patientId,
                                  _messageController.text,
                                  widget.patientName,
                                  widget.url)
                              .then(
                            (value) {
                              _messageController.clear();
                            },
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        size: 30,
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MessageItemView extends StatelessWidget {
  const MessageItemView({super.key, required this.message});

  final MessageVO message;

  @override
  Widget build(BuildContext context) {
    // Determine the color and alignment based on the sender
    Color bubbleColor =
        (message.senderID == FirebaseAuth.instance.currentUser!.uid)
            ? kSecondaryColor
            : kMessageBubbleColor;

    var alignment = (message.senderID == FirebaseAuth.instance.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(maxWidth: 200),
        decoration: BoxDecoration(
            color: bubbleColor, borderRadius: BorderRadius.circular(15)),
        child: Text(
          message.message,
          style: const TextStyle(),
        ),
      ),
    );
  }
}

class MobileChatDialog extends StatefulWidget {
  const MobileChatDialog(
      {super.key,
      required this.patientId,
      required this.patientName,
      required this.url});

  final String patientId;
  final String patientName;
  final String url;

  @override
  State<MobileChatDialog> createState() => _MobileChatDialogState();
}

class _MobileChatDialogState extends State<MobileChatDialog> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "Discussion",
              style: TextStyle(
                  color: kSecondaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: _chatController.getMessages(
                  FirebaseAuth.instance.currentUser!.uid, widget.patientId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Cannot load messages"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: LoadingWidget(),
                  );
                }

                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  Map<dynamic, dynamic> messagesMap =
                      snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  List<MessageVO> messages = messagesMap.values.map((message) {
                    return MessageVO.fromJson(
                        Map<String, dynamic>.from(message));
                  }).toList();

                  // Sort the messages by timeStamp in ascending order
                  messages.sort((a, b) => a.timeStamp.compareTo(b.timeStamp));

                  messages = messages.reversed.toList();

                  return SizedBox(
                    height: 400,
                    child: ListView(
                      reverse: true,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      // Removed reverse: true to fix the ordering
                      children: messages
                          .map((message) =>
                              MobileMessageItemView(message: message))
                          .toList(),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("No messages yet"),
                  );
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 165,
                  height: 60,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(25)),
                  child: TextField(
                    controller: _messageController,
                    cursorRadius: const Radius.circular(25),
                    decoration: InputDecoration(
                      hintText: "Send Message",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: IconButton(
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          _chatController
                              .sendMessages(
                                  widget.patientId,
                                  _messageController.text,
                                  widget.patientName,
                                  widget.url)
                              .then(
                            (value) {
                              _messageController.clear();
                            },
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MobileMessageItemView extends StatelessWidget {
  const MobileMessageItemView({super.key, required this.message});

  final MessageVO message;

  @override
  Widget build(BuildContext context) {
    // Determine the color and alignment based on the sender
    Color bubbleColor =
        (message.senderID == FirebaseAuth.instance.currentUser!.uid)
            ? kSecondaryColor
            : kMessageBubbleColor;

    var alignment = (message.senderID == FirebaseAuth.instance.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      alignment: alignment,
      child: Container(
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(maxWidth: 150),
        decoration: BoxDecoration(
            color: bubbleColor, borderRadius: BorderRadius.circular(15)),
        child: Text(
          message.message,
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/controller/add_doctor_controller.dart';
import 'package:dental_clinic/controller/appointment_controller.dart';
import 'package:dental_clinic/controller/chat_controller.dart';
import 'package:dental_clinic/controller/receptionist_home_controller.dart';
import 'package:dental_clinic/data/vos/appointment_vo.dart';
import 'package:dental_clinic/data/vos/doctor_vo.dart';
import 'package:dental_clinic/screens/receptionist_screens/add_appointment_screens/add_appointment_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/doctor_detail_screen/doctor_detail_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/emergency_saving_screens/emergency_saving_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/home_screen/all_appointment_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/patient_management_screens/patient_management_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/profile_screens/profile_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/treatment_management_screens/treatment_managament_screen.dart';
import 'package:dental_clinic/utils/file_picker_utils.dart';
import 'package:dental_clinic/utils/hover_extensions.dart';
import 'package:dental_clinic/widgets/chatted_patients_dialog.dart';
import 'package:dental_clinic/widgets/load_fail_widget.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/navigation_bar_desktop.dart';
import 'package:dental_clinic/widgets/no_connection_desktop_widget.dart';
import 'package:dental_clinic/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

final _filePicker = FilePickerUtils();
final _addDoctorController = Get.put(AddDoctorController());
final _receptionistHomeController = Get.put(ReceptionistHomeController());
final _appointmentController = Get.put(AppointmentController());

// Keep track of selected days and time slots
Map<String, List> availability = {
  "Monday": [],
  "Tuesday": [],
  "Wednesday": [],
  "Thursday": [],
  "Friday": [],
  "Saturday": [],
  "Sunday": [],
};

// Track which days are selected
Map<String, bool> selectedDays = {
  "Monday": false,
  "Tuesday": false,
  "Wednesday": false,
  "Thursday": false,
  "Friday": false,
  "Saturday": false,
  "Sunday": false,
};

class DesktopHomeScreen extends StatefulWidget {
  const DesktopHomeScreen({super.key});

  @override
  State<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  final _doctorNameController = TextEditingController();
  final _doctorSpecialistController = TextEditingController();
  final _doctorExperienceController = TextEditingController();
  final _doctorBiosController = TextEditingController();
  final _doctorIdController = TextEditingController();

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  String connection = "online";

  final _appointmentController = Get.put(AppointmentController());
  final _chatController = Get.put(ChatController());
  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 50), (timer) {
      _appointmentController.alertAppointment(context);
    });
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    startTimer();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;

    result = await _connectivity.checkConnectivity();
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
      if (_connectionStatus[0] == ConnectivityResult.none) {
        connection = "offline";
      } else {
        connection = "online";
      }
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (connection == "online") {
                showDialog(
                  context: context,
                  builder: (context) => const ChattedPatientsDialog(),
                );
              }
            },
            backgroundColor: kPrimaryColor,
            child: Obx(
              () => Stack(
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.message,
                      color: kSecondaryColor,
                      size: 40,
                    ),
                  ),
                  _chatController.replyNumber.value == 0
                      ? const SizedBox()
                      : Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kErrorColor),
                            child: Center(
                              child: Text(
                                _chatController.replyNumber.value > 9
                                    ? "9+"
                                    : _chatController.replyNumber.value
                                        .toString(),
                                style: const TextStyle(
                                    color: kPrimaryColor, fontSize: 9),
                              ),
                            ),
                          ),
                        )
                ],
              ),
            )),
        body: connection == "online"
            ? Padding(
                padding: const EdgeInsets.only(top: 50, left: 50, right: 50),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const DesktopNavigationBar(
                        title1: "Patients",
                        title2: "Emergency",
                        icon: Icons.medical_services_outlined,
                        icon2: Icons.person_outline_sharp,
                        widget1: PatientManagementScreen(),
                        widget2: EmergencySavingScreen(),
                        widget3: TreatmentManagementScreen(),
                        widget4: ReceptionistProfileScreen(),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Available Doctors",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AddDoctorDialog(
                                  function: () async {
                                    if (connection == "online") {
                                      _addDoctorController.addDoctor(
                                          _doctorNameController,
                                          _doctorIdController,
                                          _doctorBiosController,
                                          _doctorSpecialistController,
                                          _doctorExperienceController,
                                          availability,
                                          context);
                                    } else {
                                      Get.back();
                                    }
                                  },
                                  nameController: _doctorNameController,
                                  bioController: _doctorBiosController,
                                  specController: _doctorSpecialistController,
                                  expController: _doctorExperienceController,
                                  doctorIdController: _doctorIdController,
                                ),
                              );
                            },
                            child: Container(
                              width: 80,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: kSecondaryColor,
                                  borderRadius: BorderRadius.circular(6)),
                              child: const Center(
                                child: Icon(Icons.add),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Obx(
                        () => LoadingStateWidget(
                            paddingTop:
                                MediaQuery.of(context).size.height * 0.1,
                            paddingBottom:
                                MediaQuery.of(context).size.height * 0.1,
                            loadingState:
                                _receptionistHomeController.getLoadingState,
                            loadingSuccessWidget: DoctorsList(
                              doctors: _receptionistHomeController.doctorsList,
                            ),
                            loadingInitWidget: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0.1,
                                  bottom:
                                      MediaQuery.of(context).size.height * 0.1),
                              child: LoadFailWidget(
                                function: () {
                                  _receptionistHomeController.callDoctors();
                                },
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Today's Appointments",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                              const Gap(15),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: TextButton(
                                    style: const ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(
                                            kBtnGrayColor),
                                        foregroundColor: WidgetStatePropertyAll(
                                            kFourthColor)),
                                    onPressed: () => Get.to(
                                        () => const AllAppointmentScreen()),
                                    child: const Text("View All")),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => const AddAppointmentScreen());
                            },
                            child: Container(
                              width: 80,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: kSecondaryColor,
                                  borderRadius: BorderRadius.circular(6)),
                              child: const Center(
                                child: Icon(Icons.add),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Obx(
                        () => _appointmentController
                                .todayAppointmentList.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 80),
                                child: Center(
                                  child: Text(
                                    "No Appointments on this date!",
                                    style: mobileTitleStyle,
                                  ),
                                ),
                              )
                            : LoadingStateWidget(
                                paddingTop:
                                    MediaQuery.of(context).size.height * 0.1,
                                paddingBottom:
                                    MediaQuery.of(context).size.height * 0.1,
                                loadingState:
                                    _appointmentController.getLoadingState,
                                loadingSuccessWidget: AppointmentList(
                                  appointments: _appointmentController
                                      .todayAppointmentList,
                                ),
                                loadingInitWidget: Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.1,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.1),
                                  child: LoadFailWidget(
                                    function: () {
                                      _appointmentController.callAppointments();
                                    },
                                  ),
                                )),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
              )
            : const NoConnectionDesktopWidget());
  }
}

class DeleteBtn extends StatelessWidget {
  const DeleteBtn({super.key, required this.function});

  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: const ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(kBtnGrayColor)),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(kErrorColor)),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    TextButton(
                      onPressed: function,
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(kSecondaryColor)),
                      child: const Text(
                        "OK",
                        style: TextStyle(color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
              ],
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: kErrorColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Are you sure to cancel this appointment?",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kErrorColor),
                  ),
                ],
              )),
        );
      },
      child: const Text(
        "Cancel",
        style: TextStyle(color: kErrorColor),
      ),
    );
  }
}

class AppointmentList extends StatelessWidget {
  const AppointmentList({super.key, required this.appointments});

  final List<AppointmentVO> appointments;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5,
        mainAxisExtent: 300,
      ),
      itemCount: appointments.length,
      itemBuilder: (context, index) => AppointmentCard(
        appointment: appointments[index],
      ).showCursorOnHover.moveUpOnHover,
    );
  }
}

class AppointmentCard extends StatefulWidget {
  const AppointmentCard({super.key, required this.appointment});

  final AppointmentVO appointment;

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => UpdateAppointmentDialog(
            appointment: widget.appointment,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(7),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(width: 0.5),
          borderRadius: BorderRadius.circular(8), //border corner radius
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.date_range),
                const SizedBox(
                  height: 15,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: widget.appointment.date,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ])),
                const SizedBox(
                  height: 15,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: widget.appointment.time,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ])),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.appointment.status,
                  style: TextStyle(
                      color: widget.appointment.status == "Pending"
                          ? kThirdColor
                          : widget.appointment.status == "Completed"
                              ? kSuccessColor
                              : kErrorColor),
                ),
                widget.appointment.status == "Cancelled"
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextButton(
                            onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content:
                                        Text(widget.appointment.rejectReason),
                                  ),
                                ),
                            child: const Text(
                              "View Reason",
                              style: TextStyle(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.bold),
                            )),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: "Doctor : ${widget.appointment.doctorName}",
                          ),
                        ])),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: "Patient : ${widget.appointment.patientName}",
                          ),
                        ])),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpdateAppointmentDialog extends StatefulWidget {
  const UpdateAppointmentDialog({super.key, required this.appointment});

  final AppointmentVO appointment;
  @override
  State<UpdateAppointmentDialog> createState() =>
      _UpdateAppointmentDialogState();
}

class _UpdateAppointmentDialogState extends State<UpdateAppointmentDialog> {
  String? _status;

  late TextEditingController _reasonController;

  @override
  void initState() {
    _status = widget.appointment.status;
    _reasonController =
        TextEditingController(text: widget.appointment.rejectReason);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
            style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(kSecondaryColor)),
            onPressed: () {
              _appointmentController.changeAppointmentStatus(
                  context,
                  widget.appointment.id,
                  widget.appointment.doctorId,
                  widget.appointment.doctorName,
                  widget.appointment.patientId,
                  widget.appointment.patientName,
                  widget.appointment.patientPhone,
                  widget.appointment.date,
                  widget.appointment.time,
                  _status ?? "Pending",
                  _reasonController.text);
            },
            child: const Text(
              "Update",
              style: TextStyle(color: kPrimaryColor),
            ))
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Change appointment Status",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Gap(20),
          Row(
            children: <Widget>[
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Pending'),
                  value: 'Pending',
                  groupValue: _status,
                  onChanged: (String? value) {
                    setState(() {
                      _status = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Completed'),
                  value: 'Completed',
                  groupValue: _status,
                  onChanged: (String? value) {
                    setState(() {
                      _status = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('Cancelled'),
                  value: 'Cancelled',
                  groupValue: _status,
                  onChanged: (String? value) {
                    setState(() {
                      _status = value;
                    });
                  },
                ),
              ),
            ],
          ),
          _status == "Cancelled"
              ? Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: CustomTextField(
                      hintText: "Enter reason to cancel this appointment",
                      label: "Cancel Reason",
                      controller: _reasonController),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

class DoctorsList extends StatelessWidget {
  const DoctorsList({super.key, required this.doctors});

  final List<DoctorVO> doctors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 290,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          width: 15,
        ),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              Get.to(() => DoctorDetailScreen(doctor: doctors[index]));
            },
            child: DoctorCard(
              doctor: doctors[index],
            ).showCursorOnHover),
        itemCount: doctors.length,
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.doctor});

  final DoctorVO doctor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
          border: Border.all(width: 1),
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55),
                border: Border.all(width: 0.3),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(55),
                  child: Image.network(
                    doctor.url,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: "Name : ", style: TextStyle(fontSize: 18)),
                  TextSpan(
                      text: doctor.name, style: const TextStyle(fontSize: 18)),
                ])),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                RichText(
                    text: TextSpan(children: [
                  const TextSpan(
                      text: "Specialist : ",
                      style: TextStyle(fontSize: 14, color: kThirdColor)),
                  TextSpan(
                      text: doctor.specialist,
                      style: const TextStyle(fontSize: 14, color: kThirdColor)),
                ])),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
              text: TextSpan(children: [
            const TextSpan(
                text: "Experience : ",
                style: TextStyle(fontSize: 14, color: kThirdColor)),
            TextSpan(
                text: doctor.experience,
                style: const TextStyle(fontSize: 14, color: kThirdColor)),
          ])),
        ],
      ),
    );
  }
}

class AddDoctorDialog extends StatefulWidget {
  const AddDoctorDialog({
    super.key,
    required this.function,
    required this.nameController,
    required this.bioController,
    required this.specController,
    required this.expController,
    required this.doctorIdController,
  });

  final VoidCallback function;
  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController specController;
  final TextEditingController expController;
  final TextEditingController doctorIdController;

  @override
  State<AddDoctorDialog> createState() => _AddDoctorDialogState();
}

class _AddDoctorDialogState extends State<AddDoctorDialog> {
  // Method to pick time using Flutter's time picker
  Future<void> _selectTime(BuildContext context, String day) async {
    TimeOfDay? pickedStartTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedStartTime != null) {
      TimeOfDay? pickedEndTime = await showTimePicker(
        context: context,
        initialTime: pickedStartTime,
      );

      if (pickedEndTime != null) {
        setState(() {
          // Store the time slot as a string in the format "HH:mm-HH:mm"
          availability[day]?.add(
              "${pickedStartTime.format(context)} - ${pickedEndTime.format(context)}");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Obx(
          () => LoadingStateWidget(
              paddingBottom: 0,
              paddingTop: 0,
              loadingState: _addDoctorController.getLoadingState,
              loadingSuccessWidget: Center(
                child: TextButton(
                  onPressed: widget.function,
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(kSecondaryColor)),
                  child: const Text(
                    "Add",
                    style: TextStyle(color: kFourthColor),
                  ),
                ),
              ),
              loadingInitWidget: Center(
                child: TextButton(
                  onPressed: widget.function,
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(kSecondaryColor)),
                  child: const Text(
                    "Add",
                    style: TextStyle(color: kFourthColor),
                  ),
                ),
              )),
        )
      ],
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "New Doctor",
                style: TextStyle(fontSize: 28),
              ),
              const SizedBox(
                height: 40,
              ),
              Obx(
                () => Center(
                  child: Container(
                      width: 180,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 2, color: kSecondaryColor)),
                      child: _addDoctorController.selectFile.value == null
                          ? GestureDetector(
                              onTap: () async {
                                _addDoctorController.selectFile.value =
                                    await _filePicker.getImage();
                              },
                              child: const Center(
                                child: Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 40,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                _addDoctorController.selectFile.value =
                                    await _filePicker.getImage();
                              },
                              child: Container(
                                width: 180,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.memory(
                                    _addDoctorController.selectFile.value!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                hintText: "Enter doctor name",
                label: "Name",
                controller: widget.nameController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Enter doctor Id (MMR/12345)",
                label: "Doctor Id (MMR/12345)",
                controller: widget.doctorIdController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Enter doctor biography",
                label: "Biography",
                controller: widget.bioController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Enter doctor specialist",
                label: "Specialist",
                controller: widget.specController,
              ),
              const SizedBox(
                height: 20,
              ),
              CustomTextField(
                hintText: "Enter doctor experience",
                label: "Experience",
                controller: widget.expController,
              ),
              const SizedBox(height: 20),
              // Create a checkbox for each day
              SizedBox(
                height: 500,
                child: ListView(
                  shrinkWrap: true,
                  children: selectedDays.keys.map((String day) {
                    return CheckboxListTile(
                      title: Text(day),
                      value: selectedDays[day],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedDays[day] = value ?? false;
                          if (!value!) {
                            availability[day] =
                                []; // Clear time slots if unchecked
                          }
                        });
                      },
                      secondary: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: selectedDays[day]!
                            ? () => _selectTime(context, day)
                            : null, // Only allow time picking if the day is selected
                      ),
                      subtitle: Text(availability[day]!.isNotEmpty
                          ? "Selected times: ${availability[day]?.join(', ')}"
                          : "No times selected"),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

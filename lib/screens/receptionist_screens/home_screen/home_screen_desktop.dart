import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/controller/add_doctor_controller.dart';
import 'package:dental_clinic/screens/receptionist_screens/patient_management_screens/patient_management_screen.dart';
import 'package:dental_clinic/screens/receptionist_screens/profile_screens/profile_screen.dart';
import 'package:dental_clinic/utils/file_picker_utils.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/navigation_bar_desktop.dart';
import 'package:dental_clinic/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _filePicker = FilePickerUtils();
final _addDoctorController = AddDoctorController();

class DesktopHomeScreen extends StatefulWidget {
  const DesktopHomeScreen({super.key});

  @override
  State<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends State<DesktopHomeScreen> {
  final _doctorNameController = TextEditingController();
  final _doctorSpecialistController = TextEditingController();
  final _doctorExperienceController = TextEditingController();
  final _doctorDayOffController = TextEditingController();
  final _doctorBiosController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const DesktopNavigationBar(
                title1: "Patients",
                title2: "Profile",
                widget1: PatientManagementScreen(),
                widget2: ReceptionistProfileScreen(),
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Available Doctors",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddDoctorDialog(
                          function: () async {
                            _addDoctorController.addDoctor(
                                _doctorNameController,
                                _doctorBiosController,
                                _doctorSpecialistController,
                                _doctorExperienceController,
                                _doctorDayOffController,
                                context);
                          },
                          nameController: _doctorNameController,
                          bioController: _doctorBiosController,
                          specController: _doctorSpecialistController,
                          expController: _doctorExperienceController,
                          dayOffController: _doctorDayOffController,
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
              SizedBox(
                height: 300,
                child: ListView.separated(
                  separatorBuilder: (context, index) => const SizedBox(
                    width: 15,
                  ),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      GestureDetector(onTap: () {}, child: doctorCard(context)),
                  itemCount: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget doctorCard(BuildContext context) {
  return Container(
    width: 200,
    decoration: BoxDecoration(
        border: Border.all(width: 1), borderRadius: BorderRadius.circular(10)),
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
                border: Border.all(width: 0.3)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(55),
              child: Image.asset(
                "assets/images/doctor_placeholder.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 35,
        ),
        RichText(
            text: const TextSpan(children: [
          TextSpan(text: "Name : ", style: TextStyle(fontSize: 18)),
          TextSpan(text: "John", style: TextStyle(fontSize: 18)),
        ])),
        const SizedBox(
          height: 10,
        ),
        RichText(
            text: const TextSpan(children: [
          TextSpan(
              text: "Specialist : ",
              style: TextStyle(fontSize: 14, color: kThirdColor)),
          TextSpan(
              text: "General",
              style: TextStyle(fontSize: 14, color: kThirdColor)),
        ])),
        const SizedBox(
          height: 10,
        ),
        RichText(
            text: const TextSpan(children: [
          TextSpan(
              text: "Experience : ",
              style: TextStyle(fontSize: 14, color: kThirdColor)),
          TextSpan(
              text: "3 years",
              style: TextStyle(fontSize: 14, color: kThirdColor)),
        ])),
        const SizedBox(
          height: 10,
        ),
        RichText(
            text: const TextSpan(children: [
          TextSpan(
              text: "DayOff : ",
              style: TextStyle(fontSize: 14, color: kThirdColor)),
          TextSpan(
              text: "Sat/Sun",
              style: TextStyle(fontSize: 14, color: kThirdColor)),
        ])),
      ],
    ),
  );
}

class AddDoctorDialog extends StatefulWidget {
  const AddDoctorDialog(
      {super.key,
      required this.function,
      required this.nameController,
      required this.bioController,
      required this.specController,
      required this.expController,
      required this.dayOffController});

  final VoidCallback function;
  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController specController;
  final TextEditingController expController;
  final TextEditingController dayOffController;

  @override
  State<AddDoctorDialog> createState() => _AddDoctorDialogState();
}

class _AddDoctorDialogState extends State<AddDoctorDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Obx(
          () => LoadingStateWidget(
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
      content: SingleChildScrollView(
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
                        : Container(
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
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              hintText: "Enter doctor day off",
              label: "Day Off",
              controller: widget.dayOffController,
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/controller/doctor_detail_controller.dart';
import 'package:dental_clinic/data/vos/doctor_vo.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _doctorDetailController = Get.put(DoctorDetailController());

late TextEditingController _nameController;

late TextEditingController _bioController;

late TextEditingController _specialistController;

late TextEditingController _experienceController;

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

class DoctorDetailMobileScreen extends StatefulWidget {
  const DoctorDetailMobileScreen(
      {super.key, required this.doctor, required this.initialAvailability});

  final DoctorVO doctor;
  final Map<dynamic, dynamic> initialAvailability;

  @override
  State<DoctorDetailMobileScreen> createState() =>
      _DoctorDetailMobileScreenState();
}

class _DoctorDetailMobileScreenState extends State<DoctorDetailMobileScreen> {
  @override
  void initState() {
    _nameController = TextEditingController(text: widget.doctor.name);
    _bioController = TextEditingController(text: widget.doctor.bio);
    _specialistController =
        TextEditingController(text: widget.doctor.specialist);
    _experienceController =
        TextEditingController(text: widget.doctor.experience);
    populateInitialData();
    super.initState();
  }

  void populateInitialData() {
    // Iterate through the initialAvailability map to update the selectedDays and availability maps
    widget.initialAvailability.forEach((day, times) {
      if (selectedDays.containsKey(day)) {
        selectedDays[day] = true; // Set the day as selected
        availability[day] =
            List<String>.from(times); // Populate the time slots for that day
      }
    });
  }

  Future<void> _selectTime(BuildContext context, String day) async {
    final TimeOfDay? pickedStartTime = await showTimePicker(
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
    return Padding(
      padding: const EdgeInsets.all(25),
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back)),
              Obx(
                () => LoadingStateWidget(
                    loadingState: _doctorDetailController.getLoadingState,
                    loadingSuccessWidget: DeleteBtn(
                      function: () {
                        _doctorDetailController.deleteDoctor(widget.doctor.id);
                      },
                    ),
                    loadingInitWidget: DeleteBtn(
                      function: () {
                        _doctorDetailController.deleteDoctor(widget.doctor.id);
                      },
                    ),
                    paddingTop: 0),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Doctor Details",
            style: mobileTitleStyle,
          ),
          const SizedBox(
            height: 20,
          ),
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
                    widget.doctor.url,
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: SizedBox(
              width: 200,
              child: CustomTextField(
                hintText: "Enter doctor Name",
                label: "Name",
                controller: _nameController,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: SizedBox(
              width: 200,
              child: CustomTextField(
                hintText: "Enter doctor Bio",
                label: "Bio",
                controller: _bioController,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: SizedBox(
              width: 200,
              child: CustomTextField(
                hintText: "Enter doctor Specialist",
                label: "Specialist",
                controller: _specialistController,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: SizedBox(
              width: 200,
              child: CustomTextField(
                hintText: "Enter doctor experience",
                label: "Experience",
                controller: _experienceController,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: SizedBox(
              width: 250,
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
          ),
          const SizedBox(
            height: 15,
          ),
          Obx(
            () => LoadingStateWidget(
                loadingState: _doctorDetailController.getLoadingState,
                loadingSuccessWidget:
                    UpdateBtn(id: widget.doctor.id, url: widget.doctor.url),
                loadingInitWidget:
                    UpdateBtn(id: widget.doctor.id, url: widget.doctor.url),
                paddingTop: 0),
          )
        ],
      )),
    );
  }
}

class DeleteBtn extends StatelessWidget {
  const DeleteBtn({super.key, required this.function});

  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
                            backgroundColor:
                                WidgetStatePropertyAll(kErrorColor)),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
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
                      height: 15,
                    ),
                    Text(
                      "Are you sure to delete?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kErrorColor),
                    ),
                  ],
                )),
          );
        },
        icon: const Icon(
          Icons.delete,
          color: kErrorColor,
        ));
  }
}

class UpdateBtn extends StatelessWidget {
  const UpdateBtn({super.key, required this.id, required this.url});

  final int id;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _doctorDetailController.updateDoctor(
              id,
              url,
              _nameController.text,
              _bioController.text,
              _specialistController.text,
              _experienceController.text,
              availability);
        },
        child: Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
              color: kSecondaryColor, borderRadius: BorderRadius.circular(10)),
          child: const Center(
            child: Text(
              "Update",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

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

late TextEditingController _dayOffController;

class DoctorDetailMobileScreen extends StatefulWidget {
  const DoctorDetailMobileScreen({super.key, required this.doctor});

  final DoctorVO doctor;

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
    _dayOffController = TextEditingController(text: widget.doctor.dayOff);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
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
              width: 200,
              child: CustomTextField(
                hintText: "Enter doctor day off",
                label: "Day Off",
                controller: _dayOffController,
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
              _dayOffController.text);
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

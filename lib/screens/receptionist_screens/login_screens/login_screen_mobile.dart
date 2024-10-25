import 'package:dental_clinic/constants/colors.dart';
import 'package:dental_clinic/constants/text.dart';
import 'package:dental_clinic/controller/login_controller.dart';
import 'package:dental_clinic/widgets/loading_state_widget.dart';
import 'package:dental_clinic/widgets/logo.dart';
import 'package:dental_clinic/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final _loginController = Get.put(LoginController());
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  bool? showPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppLogo(),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Dental Clinic Admin Login",
                      style: mobileTitleStyle,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 250,
                  child: CustomTextField(
                    hintText: "Enter admin email",
                    label: "Email",
                    controller: _emailController,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 250,
                  child: CustomTextField(
                    controller: _passwordController,
                    hintText: "Enter your Password",
                    label: "Password",
                    isObsecure: showPassword,
                    minLines: 1,
                    maxLines: 1,
                    suffixIcon: IconButton(
                        onPressed: () {
                          showPassword = !showPassword!;
                          setState(() {});
                        },
                        icon: showPassword!
                            ? const Icon(
                                Icons.visibility_outlined,
                                color: kSecondaryColor,
                              )
                            : const Icon(
                                Icons.visibility_off_outlined,
                                color: kSecondaryColor,
                              )),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Obx(
                  () => LoadingStateWidget(
                    loadingState: _loginController.getLoadingState,
                    loadingSuccessWidget: LoginBtn(
                      function: () {
                        _loginController.login(_emailController.text,
                            _passwordController.text, context);
                      },
                    ),
                    loadingInitWidget: LoginBtn(
                      function: () {
                        _loginController.login(_emailController.text,
                            _passwordController.text, context);
                      },
                    ),
                    paddingTop: 0,
                    paddingBottom: 0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginBtn extends StatelessWidget {
  const LoginBtn({super.key, required this.function});

  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: 250,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: kSecondaryColor),
        child: const Center(
          child: Text(
            "Login",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';
import 'package:toktokapp/controllers/language_controller.dart';
import 'package:toktokapp/presentation/bloc/otp_bloc/otp_bloc.dart';
import 'package:toktokapp/controllers/theme_controller.dart';
import 'package:toktokapp/presentation/screens/map_screen.dart';

class OtpScreen extends StatelessWidget {
  final String verificationId;
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

   OtpScreen({super.key, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final otpBloc = context.read<OtpVerificationBloc>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Obx(() => Text(
              Get.find<LanguageController>().isEnglish ? 'ع' : 'EN',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            )),
            onPressed: () => Get.find<LanguageController>().toggleLanguage(),
          ),
          Spacer(),
          IconButton(
            icon: Obx(() => Icon(Get.find<ThemeController>().isDarkMode.value
                ? Icons.light_mode
                : Icons.dark_mode)),
            onPressed: () => Get.find<ThemeController>().toggleTheme(),
          ),
        ],
      ),
      body: BlocListener<OtpVerificationBloc, OtpVerificationState>(
        listener: (context, state) {
          if (state is OtpVerificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is OtpVerificationSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MapScreen()),
              (route) => false,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Lottie.asset(
                    "assets/animations/OtpAnimation.json",
                    height: 30.h,
                  ),
                ),
                SizedBox(height: 10.h),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: _otpController,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    selectedColor: Colors.deepPurple,
                    activeColor: Colors.deepPurple,
                    inactiveColor: Colors.grey,
                  ),
                  validator: (value) =>
                  value?.length == 6 ? null : 'invalid_otp'.tr,
                ),
                SizedBox(height: 20),
                BlocBuilder<OtpVerificationBloc, OtpVerificationState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(50.w, 6.h),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.deepPurple,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: state is OtpVerificationLoading
                          ? null
                          : () {
                        if (_formKey.currentState!.validate()) {
                          otpBloc.add(
                            VerifyOtpEvent(
                              verificationId: verificationId,
                              smsCode: _otpController.text,
                            ),
                          );
                        }
                      },
                      child: state is OtpVerificationLoading
                          ? const CircularProgressIndicator()
                          :  Text('verify_otp'.tr),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
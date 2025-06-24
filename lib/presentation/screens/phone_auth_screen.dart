import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:toktokapp/controllers/language_controller.dart';
import 'package:toktokapp/domain/usecases%20/otp_verification_usecase.dart';
import 'package:toktokapp/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:toktokapp/presentation/bloc/otp_bloc/otp_bloc.dart';
import 'package:toktokapp/presentation/screens/otp_screen.dart';
import 'package:toktokapp/presentation/widgets/custom_text_form.dart';
import 'package:toktokapp/controllers/theme_controller.dart';

class PhoneAuthScreen extends StatelessWidget {
  const PhoneAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: BlocListener<PhoneAuthBloc, PhoneAuthState>(
        listener: (context, state) {
          if (state is PhoneAuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is PhoneAuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => OtpVerificationBloc(
                    verificationId: state.verificationId,
                    verifyOtpUseCase: Get.find<VerifyOtpUseCase>(),
                  ),
                  child: OtpScreen(verificationId: state.verificationId),
                ),
              ),
            );
          }
        },
        child: PhoneAuthForm(),
      ),
    );
  }
}




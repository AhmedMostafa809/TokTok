import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:toktokapp/presentation/bloc/auth_bloc/auth_bloc.dart';

class PhoneAuthForm extends StatelessWidget {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  PhoneAuthForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Center(
              child: Lottie.asset(
                "assets/animations/LoginAnimation.json",
                height: 30.h,
              ),
            ),
            SizedBox(height: 10.h),
            IntlPhoneField(
              decoration: InputDecoration(
                labelText: 'phone_number'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(),
                ),
              ),
              initialCountryCode: 'EG',
              controller: _phoneController,
              validator: _validatePhoneNumber,
              invalidNumberMessage: "invalid_phone".tr,
            ),
            SizedBox(height: 20),
            BlocBuilder<PhoneAuthBloc, PhoneAuthState>(
              builder: (context, state) {
                return ElevatedButton(
                  style: _buttonStyle(),
                  onPressed: state is PhoneAuthLoading
                      ? null
                      : () => _onSendOtpPressed(context),
                  child: state is PhoneAuthLoading
                      ? const CircularProgressIndicator()
                      : Text('send_otp'.tr),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String? _validatePhoneNumber(PhoneNumber? phoneNumber) {
    if (phoneNumber == null || phoneNumber.number.isEmpty) {
      return 'invalid_phone'.tr;
    }
    final fullNumber = phoneNumber.completeNumber;
    if (!RegExp(r'^\+\d{1,3}\d{9,10}$').hasMatch(fullNumber)) {
      return 'invalid_phone_format'.tr;
    }
    return null;
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      fixedSize: Size(50.w, 6.h),
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.deepPurple, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  void _onSendOtpPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<PhoneAuthBloc>().add(
        SendOtpEvent("+20${_phoneController.text}"),
      );
    }
  }
}
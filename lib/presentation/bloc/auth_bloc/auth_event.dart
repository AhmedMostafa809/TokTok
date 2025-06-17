part of 'auth_bloc.dart';

abstract class PhoneAuthEvent  {}

class SendOtpEvent extends PhoneAuthEvent {
  final String phoneNumber;

  SendOtpEvent(this.phoneNumber);
}
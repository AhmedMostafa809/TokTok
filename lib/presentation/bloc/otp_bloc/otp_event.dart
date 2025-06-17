part of 'otp_bloc.dart';

abstract class OtpVerificationEvent extends Equatable {}

class VerifyOtpEvent extends OtpVerificationEvent {
  final String verificationId;
  final String smsCode;

  VerifyOtpEvent({
    required this.verificationId,
    required this.smsCode,
  });

  @override
  List<Object?> get props => [verificationId, smsCode];

}
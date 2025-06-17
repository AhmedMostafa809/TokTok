part of 'otp_bloc.dart';

abstract class OtpVerificationState extends Equatable {}

class OtpVerificationInitial extends OtpVerificationState {
  final String verificationId;

  OtpVerificationInitial(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}

class OtpVerificationLoading extends OtpVerificationState {
  @override
  List<Object> get props => [];
}

class OtpVerificationSuccess extends OtpVerificationState {
  @override
  List<Object> get props => [];
}

class OtpVerificationError extends OtpVerificationState {
  final String error;

  OtpVerificationError(this.error);

  @override
  List<Object> get props => [error];
}
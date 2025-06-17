part of 'auth_bloc.dart';


abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoading extends PhoneAuthState {}

class PhoneAuthSuccess extends PhoneAuthState {
  final String verificationId;
  final int? resendToken;

  PhoneAuthSuccess(this.verificationId, this.resendToken);
}

class PhoneAuthError extends PhoneAuthState {
  final String error;

  PhoneAuthError(this.error);
}
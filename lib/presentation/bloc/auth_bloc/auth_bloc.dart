import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toktokapp/domain/usecases%20/send_otp_usecase.dart';
part 'auth_event.dart';
part 'auth_state.dart';


class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final SendOtpUseCase sendOtpUseCase;

  PhoneAuthBloc(this.sendOtpUseCase) : super(PhoneAuthInitial()) {
    on<SendOtpEvent>(onSendOtp);
  }
  Future<void> onSendOtp(
      SendOtpEvent event,
      Emitter<PhoneAuthState> emit,
      ) async {
    emit(PhoneAuthLoading());
    final result = await sendOtpUseCase.loginWithPhoneNumber(event.phoneNumber);

    result.error != null
        ? emit(PhoneAuthError(result.error!))
        : emit(PhoneAuthSuccess(result.verificationId!, result.resendToken));
  }
}
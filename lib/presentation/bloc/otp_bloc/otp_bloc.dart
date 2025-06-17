import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:toktokapp/domain/usecases%20/otp_verification_usecase.dart';

part 'otp_event.dart';
part 'otp_state.dart';


class OtpVerificationBloc
    extends Bloc<OtpVerificationEvent, OtpVerificationState>{
  final VerifyOtpUseCase verifyOtpUseCase;

  OtpVerificationBloc({
    required String verificationId,
    required this.verifyOtpUseCase,
  }) : super(OtpVerificationInitial(verificationId)) {
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  Future<void> _onVerifyOtp(
      VerifyOtpEvent event,
      Emitter<OtpVerificationState> emit,
      ) async {
    emit(OtpVerificationLoading());
    final result = await verifyOtpUseCase.submitOtp(
      verificationId: event.verificationId,
      smsCode: event.smsCode,
    );

    result.error != null
        ? emit(OtpVerificationError(result.error!))
        : emit(OtpVerificationSuccess());
  }
}
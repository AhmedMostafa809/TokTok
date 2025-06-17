import '../entities/otp_verification_entity.dart';
import '../repositories/otp_verification_repository.dart';

class VerifyOtpUseCase {
  final OtpVerificationRepository repository;

  const VerifyOtpUseCase(this.repository);

  Future<OtpVerificationEntity> submitOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    return await repository.verifyOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}
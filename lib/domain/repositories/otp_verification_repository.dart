import 'package:toktokapp/domain/entities/otp_verification_entity.dart';

abstract class OtpVerificationRepository {
  Future<OtpVerificationEntity> verifyOtp({
    required String verificationId,
    required String smsCode,
  });
}
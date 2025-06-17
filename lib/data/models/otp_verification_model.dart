import 'package:firebase_auth/firebase_auth.dart';
import 'package:toktokapp/domain/entities/otp_verification_entity.dart';

class OtpVerificationModel extends OtpVerificationEntity {
  final UserCredential? userCredential;

  const OtpVerificationModel({
    required super.verificationId,
    required super.smsCode,
    super.error,
    this.userCredential,
  });
}
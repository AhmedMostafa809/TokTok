class OtpVerificationEntity {
  final String verificationId;
  final String smsCode;
  final String? error;

  const OtpVerificationEntity({
    required this.verificationId,
    required this.smsCode,
    this.error,
  });
}
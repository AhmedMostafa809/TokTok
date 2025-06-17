class PhoneAuthEntity {
  final String? verificationId;
  final int? resendToken;
  final String? error;

  PhoneAuthEntity({
    this.verificationId,
    this.resendToken,
    this.error,
  });
}
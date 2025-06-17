import 'package:firebase_auth/firebase_auth.dart';
import 'package:toktokapp/domain/entities/phone_auth_entity.dart';

class PhoneAuthModel extends PhoneAuthEntity {
  final PhoneAuthCredential? credential;

  PhoneAuthModel({
    this.credential,
    super.verificationId,
    super.resendToken,
    super.error,
  });
}
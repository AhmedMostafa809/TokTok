import 'package:firebase_auth/firebase_auth.dart';
import 'package:toktokapp/data/models/otp_verification_model.dart';

abstract class OtpVerificationRemoteDataSource {
  Future<OtpVerificationModel> verifyOtp({
    required String verificationId,
    required String smsCode,
  });
}

class OtpVerificationRemoteDataSourceImpl
    implements OtpVerificationRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  const OtpVerificationRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<OtpVerificationModel> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final userCredential = await firebaseAuth.signInWithCredential(credential);

      return OtpVerificationModel(
        verificationId: verificationId,
        smsCode: smsCode,
        userCredential: userCredential,
      );
    } on FirebaseAuthException catch (e) {
      return OtpVerificationModel(
        verificationId: verificationId,
        smsCode: smsCode,
        error: e.message ?? 'OTP verification failed',
      );
    }
  }
}
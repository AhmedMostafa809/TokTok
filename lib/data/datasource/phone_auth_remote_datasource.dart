import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:toktokapp/data/models/phone_auth_model.dart';

abstract class PhoneAuthRemoteDataSource {
  Future<PhoneAuthModel> sendOtp(String phoneNumber);
}


class PhoneAuthRemoteDataSourceImpl implements PhoneAuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  const PhoneAuthRemoteDataSourceImpl(this.firebaseAuth);

  @override
  Future<PhoneAuthModel> sendOtp(String phoneNumber) async {
    final completer = Completer<PhoneAuthModel>();

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) {
        if (!completer.isCompleted) {
          completer.complete(PhoneAuthModel(credential: credential));
        }
      },
      verificationFailed: (e) {
        if (!completer.isCompleted) {
          completer.complete(PhoneAuthModel(error: e.message));
        }
      },
      codeSent: (verificationId, resendToken) {
        if (!completer.isCompleted) {
          completer.complete(PhoneAuthModel(
            verificationId: verificationId,
            resendToken: resendToken,
          ));
        }
      },
      codeAutoRetrievalTimeout: (verificationId) {
        if (!completer.isCompleted) {
          completer.complete(PhoneAuthModel(verificationId: verificationId));
        }
      },
    );

    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () => PhoneAuthModel(error: 'Timeout'),
    );
  }
}
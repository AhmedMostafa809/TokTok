import 'package:toktokapp/data/datasource/otp_verification_remote_datasource.dart';
import 'package:toktokapp/domain/entities/otp_verification_entity.dart';
import 'package:toktokapp/domain/repositories/otp_verification_repository.dart';

class OtpVerificationRepositoryImpl implements OtpVerificationRepository {
  final OtpVerificationRemoteDataSource remoteDataSource;

  const OtpVerificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<OtpVerificationEntity> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    final model = await remoteDataSource.verifyOtp(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return model;
  }
}
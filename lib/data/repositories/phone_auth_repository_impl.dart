import 'package:toktokapp/data/datasource/phone_auth_remote_datasource.dart';
import 'package:toktokapp/domain/entities/phone_auth_entity.dart';
import 'package:toktokapp/domain/repositories/phone_auth_repository.dart';

class PhoneAuthRepositoryImpl implements PhoneAuthRepository {
  final PhoneAuthRemoteDataSource remoteDataSource;

  const PhoneAuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<PhoneAuthEntity> sendOtp(String phoneNumber) async {
    try {
      final model = await remoteDataSource.sendOtp(phoneNumber);
      return PhoneAuthEntity(
        verificationId: model.verificationId,
        resendToken: model.resendToken,
        error: model.error,
      );
    } catch (e) {
      return PhoneAuthEntity(error: e.toString());
    }
  }
}
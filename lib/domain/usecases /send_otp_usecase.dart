import 'package:toktokapp/domain/entities/phone_auth_entity.dart';
import 'package:toktokapp/domain/repositories/phone_auth_repository.dart';

class SendOtpUseCase {
  final PhoneAuthRepository repository;

  SendOtpUseCase(this.repository);

  Future<PhoneAuthEntity> loginWithPhoneNumber(String phoneNumber) async {
    return await repository.sendOtp(phoneNumber);
  }
}
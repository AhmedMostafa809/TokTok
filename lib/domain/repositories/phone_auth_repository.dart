import 'package:toktokapp/domain/entities/phone_auth_entity.dart';

abstract class PhoneAuthRepository {
  Future<PhoneAuthEntity> sendOtp(String phoneNumber);
}
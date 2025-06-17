import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toktokapp/domain/entities/otp_verification_entity.dart';
import 'package:toktokapp/domain/repositories/otp_verification_repository.dart';
import 'package:toktokapp/domain/usecases%20/otp_verification_usecase.dart';
import 'package:toktokapp/presentation/bloc/otp_bloc/otp_bloc.dart';


class MockVerifyOtpUseCase implements VerifyOtpUseCase {
  OtpVerificationEntity? mockResponse;
  Exception? mockException;

  @override
  Future<OtpVerificationEntity> submitOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    if (mockException != null) {
      throw mockException!;
    }
    return mockResponse!;
  }

  @override
  // TODO: implement repository
  OtpVerificationRepository get repository => throw UnimplementedError();
}

void main() {
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late OtpVerificationBloc otpVerificationBloc;
  const String testVerificationId = 'testVerificationId';
  const String testSmsCode = '121212';

  setUp(() {
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    otpVerificationBloc = OtpVerificationBloc(
      verificationId: testVerificationId,
      verifyOtpUseCase: mockVerifyOtpUseCase,
    );
  });

  tearDown(() {
    otpVerificationBloc.close();
  });

  group('OtpVerificationBloc', () {

    test('initial state is OtpVerificationInitial with verificationId', () {
      expect(
        otpVerificationBloc.state,
        equals(OtpVerificationInitial(testVerificationId)),
      );
    });

    blocTest<OtpVerificationBloc, OtpVerificationState>(
      'emits OtpVerificationLoading, OtpVerificationSuccess when VerifyOtpEvent succeeds',
      build: () {
        mockVerifyOtpUseCase.mockResponse = OtpVerificationEntity(
          verificationId: testVerificationId,
          smsCode: testSmsCode,
        );
        return otpVerificationBloc;
      },
      act: (bloc) => bloc.add(VerifyOtpEvent(
        verificationId: testVerificationId,
        smsCode: testSmsCode,
      )),
      expect: () => [
        OtpVerificationLoading(),
        OtpVerificationSuccess(),
      ],
    );

    blocTest<OtpVerificationBloc, OtpVerificationState>(
      'emits OtpVerificationLoading, OtpVerificationError when VerifyOtpEvent fails',
      build: () {
        mockVerifyOtpUseCase.mockResponse = OtpVerificationEntity(
          verificationId: testVerificationId,
          smsCode: testSmsCode,
          error: 'Verification failed',
        );
        return otpVerificationBloc;
      },
      act: (bloc) => bloc.add(VerifyOtpEvent(
        verificationId: testVerificationId,
        smsCode: testSmsCode,
      )),
      expect: () => [
        OtpVerificationLoading(),
        OtpVerificationError(mockVerifyOtpUseCase.mockResponse!.error.toString()),
      ],
    );

  });
}
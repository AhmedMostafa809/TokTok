import 'package:firebase_auth/firebase_auth.dart';
import 'package:toktokapp/data/datasource/otp_verification_remote_datasource.dart';
import 'package:toktokapp/data/datasource/phone_auth_remote_datasource.dart';
import 'package:toktokapp/data/repositories/otp_verification_remote_datasource_impl.dart';
import 'package:toktokapp/data/repositories/phone_auth_repository_impl.dart';
import 'package:toktokapp/domain/repositories/otp_verification_repository.dart';
import 'package:toktokapp/domain/repositories/phone_auth_repository.dart';
import 'package:toktokapp/domain/usecases%20/otp_verification_usecase.dart';
import 'package:toktokapp/domain/usecases%20/send_otp_usecase.dart';
import 'package:toktokapp/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:toktokapp/presentation/bloc/map_bloc.dart';
import 'package:toktokapp/presentation/bloc/otp_bloc/otp_bloc.dart';

class AppDependencies {
  final FirebaseAuth firebaseAuth;

  late final PhoneAuthRemoteDataSource phoneAuthRemoteDataSource;
  late final PhoneAuthRepository phoneAuthRepository;
  late final SendOtpUseCase sendOtpUseCase;
  late final PhoneAuthBloc phoneAuthBloc;

  late final OtpVerificationRemoteDataSource otpVerificationRemoteDataSource;
  late final OtpVerificationRepository otpVerificationRepository;
  late final VerifyOtpUseCase verifyOtpUseCase;
  late final OtpVerificationBloc otpVerificationBloc;

  late final MapBloc mapBloc;

  AppDependencies(this.firebaseAuth) {
    phoneAuthRemoteDataSource = PhoneAuthRemoteDataSourceImpl(firebaseAuth);
    phoneAuthRepository = PhoneAuthRepositoryImpl(phoneAuthRemoteDataSource);
    sendOtpUseCase = SendOtpUseCase(phoneAuthRepository);
    phoneAuthBloc = PhoneAuthBloc(sendOtpUseCase);
    otpVerificationRemoteDataSource = OtpVerificationRemoteDataSourceImpl(firebaseAuth);
    otpVerificationRepository = OtpVerificationRepositoryImpl(otpVerificationRemoteDataSource);
    verifyOtpUseCase = VerifyOtpUseCase(otpVerificationRepository);
    otpVerificationBloc = OtpVerificationBloc(verifyOtpUseCase: verifyOtpUseCase,verificationId: "");
    mapBloc = MapBloc();
  }
}
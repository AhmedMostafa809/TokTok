import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:toktokapp/controllers/language_controller.dart';
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
import 'package:toktokapp/presentation/screens/splash_screen.dart';
import 'package:toktokapp/controllers/theme_controller.dart';
import 'package:toktokapp/translations/app_translation.dart';
import 'package:toktokapp/presentation/screens/otp_screen.dart';
import 'package:toktokapp/presentation/screens/phone_auth_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final firebaseAuth = FirebaseAuth.instance;
  final dependencies = AppDependencies(firebaseAuth);
  runApp(MyApp(
    dependencies: dependencies
  ));
}

class MyApp extends StatelessWidget {
  final AppDependencies dependencies;
  MyApp({super.key, required this.dependencies});




  final ThemeController themeController = Get.put(ThemeController());
  final languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
            providers: [
              BlocProvider<PhoneAuthBloc>.value(value: dependencies.phoneAuthBloc),
              BlocProvider<OtpVerificationBloc>.value(value: dependencies.otpVerificationBloc),
              BlocProvider<MapBloc>.value(value: dependencies.mapBloc),
            ],
            child: MultiRepositoryProvider(
              providers: [
                RepositoryProvider<VerifyOtpUseCase>.value(value: dependencies.verifyOtpUseCase),
              ],
              child: GetMaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
                themeMode: themeController.theme,
                locale: Locale(languageController.currentLanguage.value),
                textDirection:
                languageController.isEnglish
                    ? TextDirection.ltr
                    : TextDirection.ltr,
                // translations: AppTranslations(),
                // localizationsDelegates: AppLocalizations.localizationsDelegates,
                // supportedLocales: AppLocalizations.supportedLocales,
                home: SplashScreen(),
              ),
            )
        );
      },
    );
  }
}

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

// void initDependencies() {
//   Get.lazyPut<PhoneAuthRemoteDataSource>(
//         () => PhoneAuthRemoteDataSourceImpl(FirebaseAuth.instance),
//   );
//
//   Get.lazyPut<PhoneAuthRepository>(
//         () => PhoneAuthRepositoryImpl(Get.find<PhoneAuthRemoteDataSource>()),
//   );
//
//   Get.lazyPut(() => SendOtpUseCase(Get.find<PhoneAuthRepository>()));
//
//   Get.lazyPut(() => PhoneAuthBloc(Get.find<SendOtpUseCase>()));
//
//   Get.lazyPut<OtpVerificationRemoteDataSource>(
//         () => OtpVerificationRemoteDataSourceImpl(FirebaseAuth.instance),
//   );
//
//   Get.lazyPut<OtpVerificationRepository>(
//         () =>
//         OtpVerificationRepositoryImpl(
//           Get.find<OtpVerificationRemoteDataSource>(),
//         ),
//   );
//
//   Get.lazyPut(() => VerifyOtpUseCase(Get.find<OtpVerificationRepository>()));
//
//   Get.lazyPut(() => MapBloc());
// }
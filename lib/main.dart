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
import 'package:toktokapp/presentation/bloc/otp_bloc/otp_bloc.dart';
import 'package:toktokapp/presentation/screens/map_screen.dart';
import 'package:toktokapp/presentation/screens/phone_auth_screen.dart';
import 'package:toktokapp/presentation/screens/splash_screen.dart';
import 'package:toktokapp/controllers/theme_controller.dart';
import 'package:toktokapp/translations/app_translation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeController themeController = Get.put(ThemeController());
  final languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Obx(
          () => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => Get.find<PhoneAuthBloc>()),
              BlocProvider(
                create: (context) => Get.find<OtpVerificationBloc>(),
              ),
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
              translations: AppTranslations(),
              home: SplashScreen(),
            ),
          ),
        );
      },
    );
  }
}

void initDependencies() {
  Get.lazyPut<PhoneAuthRemoteDataSource>(
    () => PhoneAuthRemoteDataSourceImpl(FirebaseAuth.instance),
  );

  Get.lazyPut<PhoneAuthRepository>(
    () => PhoneAuthRepositoryImpl(Get.find<PhoneAuthRemoteDataSource>()),
  );

  Get.lazyPut(() => SendOtpUseCase(Get.find<PhoneAuthRepository>()));

  Get.lazyPut(() => PhoneAuthBloc(Get.find<SendOtpUseCase>()));

  Get.lazyPut<OtpVerificationRemoteDataSource>(
    () => OtpVerificationRemoteDataSourceImpl(FirebaseAuth.instance),
  );

  Get.lazyPut<OtpVerificationRepository>(
    () => OtpVerificationRepositoryImpl(
      Get.find<OtpVerificationRemoteDataSource>(),
    ),
  );

  Get.lazyPut(() => VerifyOtpUseCase(Get.find<OtpVerificationRepository>()));
}

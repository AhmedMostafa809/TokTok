import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';
import 'package:toktokapp/app_dependencies.dart';
import 'package:toktokapp/controllers/language_controller.dart';
import 'package:toktokapp/data/datasource/otp_verification_remote_datasource.dart';
import 'package:toktokapp/data/datasource/phone_auth_remote_datasource.dart';
import 'package:toktokapp/data/repositories/otp_verification_remote_datasource_impl.dart';
import 'package:toktokapp/data/repositories/phone_auth_repository_impl.dart';
import 'package:toktokapp/domain/repositories/otp_verification_repository.dart';
import 'package:toktokapp/domain/repositories/phone_auth_repository.dart';
import 'package:toktokapp/domain/usecases%20/otp_verification_usecase.dart';
import 'package:toktokapp/domain/usecases%20/send_otp_usecase.dart';
import 'package:toktokapp/presentation/bloc/localization_bloc/localization_bloc.dart';
import 'package:toktokapp/presentation/bloc/localization_bloc/localization_event.dart';
import 'package:toktokapp/presentation/bloc/localization_bloc/localization_state.dart';
import 'package:toktokapp/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:toktokapp/presentation/bloc/map_bloc.dart';
import 'package:toktokapp/presentation/bloc/otp_bloc/otp_bloc.dart';
import 'package:toktokapp/presentation/screens/splash_screen.dart';
import 'package:toktokapp/controllers/theme_controller.dart';
import 'package:toktokapp/translations/app_translation.dart';
import 'package:toktokapp/presentation/screens/otp_screen.dart';
import 'package:toktokapp/presentation/screens/phone_auth_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  final firebaseAuth = FirebaseAuth.instance;
  final dependencies = AppDependencies(firebaseAuth);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      saveLocale: true,
      child: MyApp(dependencies: dependencies),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppDependencies dependencies;

  const MyApp({super.key, required this.dependencies});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<PhoneAuthBloc>.value(value: dependencies.phoneAuthBloc),
            BlocProvider<OtpVerificationBloc>.value(value: dependencies.otpVerificationBloc),
            BlocProvider<MapBloc>.value(value: dependencies.mapBloc),
            BlocProvider<LanguageBloc>(
              create: (_) => LanguageBloc(),
            ),
          ],
          child: BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, langState) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
                themeMode: ThemeMode.system,
                locale: langState.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                home: const SplashScreen(),
              );
            },
          ),
        );
      },
    );
  }
}

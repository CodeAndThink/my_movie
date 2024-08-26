import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_movie/data/repository/auth_repository.dart';
import 'package:my_movie/data/repository/movie_repository.dart';
import 'package:my_movie/screens/login/check_initial_screen.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/settings_bloc/settings_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/settings_bloc/settings_state.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('6LeMrC8qAAAAAHijhXjPmdw0gPgcBaQLn2HBWcdM'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => AuthBloc(AuthRepository(FirebaseAuth.instance))),
      BlocProvider(create: (context) => MovieBloc(MovieRepository())),
      BlocProvider(create: (context) => SettingsBloc()),
      BlocProvider(create: (context) => UserDataBloc(AuthRepository(FirebaseAuth.instance)))
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          theme: state.themeData,
          locale: state.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CheckInitialScreen(),
        );
      },
    );
  }
}

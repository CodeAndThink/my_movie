import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_movie/data/repository/auth_repository.dart';
import 'package:my_movie/data/repository/movie_repository.dart';
import 'package:my_movie/data/repository/quizz_repository.dart';
import 'package:my_movie/screens/login/check_initial_screen.dart';
import 'package:my_movie/screens/main/viewmodel/auth_bloc/auth_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/comment_bloc/comment_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/movie_bloc/movie_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/notification_bloc/notification_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/quizz_bloc/quizz_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/settings_bloc/settings_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/settings_bloc/settings_state.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_bloc.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  setupFirebaseMessaging();
  await FirebaseAppCheck.instance.activate(
    webProvider:
        ReCaptchaV3Provider('6LeMrC8qAAAAAHijhXjPmdw0gPgcBaQLn2HBWcdM'),
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  final authRepository = AuthRepository(FirebaseAuth.instance);
  final movieRepository = MovieRepository();
  final quizzRepository = QuizzRepository();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
          create: (context) => CommentBloc(authRepository, movieRepository)),
      BlocProvider(create: (context) => AuthBloc(authRepository)),
      BlocProvider(create: (context) => MovieBloc(movieRepository)),
      BlocProvider(create: (context) => SettingsBloc()),
      BlocProvider(create: (context) => UserDataBloc(authRepository)),
      BlocProvider(create: (context) => QuizzBloc(quizzRepository)),
      BlocProvider(create: (context) => NotificationBloc(authRepository))
    ],
    child: const MyApp(),
  ));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Xử lý thông báo ở chế độ nền: ${message.messageId}");
}

void setupFirebaseMessaging() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Xử lý thông báo ở chế độ foreground: ${message.messageId}");
    if (message.notification != null) {
      showNotification(
        message.notification!.title,
        message.notification!.body,
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Thông báo đã được mở: ${message.messageId}");
  });
}

void showNotification(String? title, String? body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    platformChannelSpecifics,
    payload: 'item x',
  );
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

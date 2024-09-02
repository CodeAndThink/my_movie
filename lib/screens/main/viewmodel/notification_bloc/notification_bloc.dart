import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_movie/data/models/notification_model.dart';
import 'package:my_movie/data/repository/auth_repository.dart';
import 'package:my_movie/screens/main/viewmodel/notification_bloc/notification_event.dart';
import 'package:my_movie/screens/main/viewmodel/notification_bloc/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final AuthRepository _authRepository;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationBloc(this._authRepository) : super(NotificationInitial()) {
    _initializeNotifications();
    on<LoadNotifications>(_onLoadNotifications);
    on<SubscribeToTopic>(_onSubscribeToTopic);
    on<UnsubscribeFromTopic>(_onUnsubscribeFromTopic);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      add(LoadNotifications(message));
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      add(LoadNotifications(message));
    });
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // Handle background message
  }

  void _showNotification(String? title, String? body) async {
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
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _onLoadNotifications(
      LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final title = event.message.notification?.title ?? 'No title';
      final body = event.message.notification?.body ?? 'No body';

      _showNotification(title, body);

      final currentState = state;
      List<NotificationModel> updatedMessages;

      if (currentState is NotificationLoaded) {
        updatedMessages = List.from(currentState.messages)
          ..add(NotificationModel(
              title: title,
              body: body,
              timestamp: DateTime.now(),
              seen: false));
      } else {
        updatedMessages = [
          NotificationModel(
              title: title, body: body, timestamp: DateTime.now(), seen: false),
        ];
      }

      await _authRepository.storeNotifications(updatedMessages);

      final messages = await _authRepository.loadNotifications();

      emit(NotificationLoaded(messages));
    } catch (e) {
      emit(NotificationLoadedFailure(e.toString()));
    }
  }

  Future<void> _onSubscribeToTopic(
      SubscribeToTopic event, Emitter<NotificationState> emit) async {
    try {
      await _authRepository.subscribeToTopic(event.topic);
      emit(NotificationTopicUpdated(event.topic, true));
    } catch (e) {
      emit(NotificationUpdatedFailure(e.toString()));
    }
  }

  Future<void> _onUnsubscribeFromTopic(
      UnsubscribeFromTopic event, Emitter<NotificationState> emit) async {
    try {
      await _authRepository.unsubscribeFromTopic(event.topic);
      emit(NotificationTopicUpdated(event.topic, false));
    } catch (e) {
      emit(NotificationUpdatedFailure(e.toString()));
    }
  }
}

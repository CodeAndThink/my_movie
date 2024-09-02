import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final RemoteMessage message;

  LoadNotifications(this.message);

  @override
  List<Object> get props => [message];
}

class SubscribeToTopic extends NotificationEvent {
  final String topic;

  SubscribeToTopic(this.topic);

  @override
  List<Object> get props => [topic];
}

class UnsubscribeFromTopic extends NotificationEvent {
  final String topic;

  UnsubscribeFromTopic(this.topic);

  @override
  List<Object> get props => [topic];
}

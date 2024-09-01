import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {}

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

import 'package:equatable/equatable.dart';
import 'package:my_movie/data/models/notification_model.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> messages;

  NotificationLoaded( this.messages);

  @override
  List<Object> get props => [messages];
}

class NotificationLoadedFailure extends NotificationState {
  final String message;

  NotificationLoadedFailure(this.message);

  @override
  List<Object> get props => [message];
}

class NotificationTopicUpdated extends NotificationState {
  final String topic;
  final bool subscribed;

  NotificationTopicUpdated(this.topic, this.subscribed);

  @override
  List<Object> get props => [topic, subscribed];
}

class NotificationUpdatedFailure extends NotificationState {
  final String message;

  NotificationUpdatedFailure(this.message);

  @override
  List<Object> get props => [message];
}

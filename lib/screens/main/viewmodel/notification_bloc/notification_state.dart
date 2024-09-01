import 'package:equatable/equatable.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final String deviceToken;

  NotificationLoaded({required this.deviceToken});

  @override
  List<Object> get props => [deviceToken];
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

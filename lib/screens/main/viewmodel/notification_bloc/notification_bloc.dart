import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/repository/auth_repository.dart';
import 'package:my_movie/screens/main/viewmodel/notification_bloc/notification_event.dart';
import 'package:my_movie/screens/main/viewmodel/notification_bloc/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final AuthRepository _authRepository;

  NotificationBloc(this._authRepository) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<SubscribeToTopic>(_onSubscribeToTopic);
    on<UnsubscribeFromTopic>(_onUnsubscribeFromTopic);
  }

  Future<void> _onLoadNotifications(
      LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final deviceToken = await _authRepository.getDeviceToken();
      emit(NotificationLoaded(deviceToken: deviceToken));
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/notification_bloc/notification_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/notification_bloc/notification_event.dart';
import 'package:my_movie/screens/main/viewmodel/notification_bloc/notification_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<NotificationBloc>().add(LoadNotifications());

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationLoaded) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Device Token: ${state.deviceToken}'),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<NotificationBloc>()
                          .add(SubscribeToTopic('news'));
                    },
                    child: const Text('Subscribe to News'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<NotificationBloc>()
                          .add(UnsubscribeFromTopic('news'));
                    },
                    child: const Text('Unsubscribe from News'),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationLoadedFailure) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is NotificationUpdatedFailure) {
            return Center(child: Text('Error: ${state.message}'));
          }

          return const Center(child: Text('No notifications'));
        },
      ),
    );
  }
}

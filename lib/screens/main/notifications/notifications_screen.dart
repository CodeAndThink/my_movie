import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/constain_values/values.dart';
import 'package:my_movie/screens/main/notifications/list_item/notification_card.dart';
import 'package:my_movie/screens/main/viewmodel/notification_bloc/notification_bloc.dart';
import 'package:my_movie/screens/main/viewmodel/notification_bloc/notification_event.dart';
import 'package:my_movie/screens/main/viewmodel/notification_bloc/notification_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  void subscribeToAllTopic() {
    for (NotificationTopic topic in NotificationTopic.values) {
      context.read<NotificationBloc>().add(SubscribeToTopic(topic.name));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.notifications)),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationLoaded) {
            return ListView.builder(
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                return NotificationCard(
                  notification: message,
                  onTap: (notification) {
                    showNotificationDetails(context, notification);
                  },
                );
              },
            );
          } else if (state is NotificationUpdatedFailure) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Center(
                child:
                    Text(AppLocalizations.of(context)!.loadNotificationsError));
          }
        },
      ),
    );
  }
}

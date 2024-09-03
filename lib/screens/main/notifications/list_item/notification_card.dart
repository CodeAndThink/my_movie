import 'package:flutter/material.dart';
import 'package:my_movie/data/models/notification_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final Function(NotificationModel) onTap;
  final bool seen;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.seen,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        margin: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ListTile(
              title: Text(notification.title ?? 'No Title'),
              subtitle: Text(notification.body ?? 'No Content'),
              onTap: () => onTap(notification),
            ),
            seen
                ? const Icon(Icons.newspaper)
                : const Icon(Icons.newspaper_outlined)
          ],
        ));
  }
}

void showNotificationDetails(
    BuildContext context, NotificationModel notification) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(notification.title ?? 'No Title'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 1,
              ),
              Text(notification.body ?? 'No Content'),
              const SizedBox(height: 10),
              Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 1,
              ),
              Text(
                AppLocalizations.of(context)!.details,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(AppLocalizations.of(context)!.createAt(
                  notification.timestamp
                      .toString()
                      .split(' ')
                      .first
                      .split('-')
                      .reversed
                      .join('/'),
                  notification.timestamp
                      .toString()
                      .split(' ')[1]
                      .substring(0, 8))),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

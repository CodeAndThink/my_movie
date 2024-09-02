import 'package:intl/intl.dart';

class NotificationModel {
  final String? title;
  final String? body;
  final DateTime? timestamp;
  final bool? seen;

  NotificationModel({this.title, this.body, this.timestamp, this.seen});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] as String?,
      body: json['body'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
      seen: json['seen'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'timestamp': timestamp != null
          ? DateFormat('yyyy-MM-ddTHH:mm:ss').format(timestamp!)
          : null,
      'seen': seen,
    };
  }
}

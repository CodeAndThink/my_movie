class NotificationModel {
  final String id;
  final String title;
  final String content;
  final String createDate;
  final String icons;
  final String? imageUrl;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createDate,
    required this.icons,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createDate': createDate,
      'icons': icons,
      'imageUrl': imageUrl,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createDate: json['createDate'] as String,
      icons: json['icons'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

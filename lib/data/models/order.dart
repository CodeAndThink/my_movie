import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_movie/data/models/gift.dart';

class Order {
  final String userDocId;
  final String productDocId;
  final Gift gift;
  final int quantity;
  final DateTime timestamp;

  Order({
    required this.userDocId,
    required this.productDocId,
    required this.gift,
    required this.quantity,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'userDocId': userDocId,
      'productDocId': productDocId,
      'gift': gift.toJson(),
      'quantity': quantity,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      gift: Gift.fromJson(json['gift'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      userDocId: json['userDocId'] as String,
      productDocId: json['productDocId'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }
}

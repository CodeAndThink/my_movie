import 'package:cloud_firestore/cloud_firestore.dart';

class Gift {
  final String name;
  final List<String> url;
  final String price;
  final int quantity;
  final String source;
  final DateTime mfgDate; // Manufacturing date
  final DateTime? expDate; // Expiry date

  Gift({
    required this.name,
    required this.url,
    required this.price,
    required this.quantity,
    required this.source,
    required this.mfgDate,
    this.expDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'price': price,
      'quantity': quantity,
      'source': source,
      'mfgDate': mfgDate.toIso8601String(),
      'expDate': expDate?.toIso8601String(),
    };
  }

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      name: json['name'],
      url: List<String>.from(json['url']),
      price: json['price'],
      quantity: int.parse(json['quantity']),
      source: json['source'],
      mfgDate: (json['mfgDate'] as Timestamp).toDate(),
      expDate: json['expDate'] != null
          ? (json['expDate'] as Timestamp).toDate()
          : null,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_movie/data/models/gift.dart';
import 'package:my_movie/data/models/gift_item.dart';
import 'package:my_movie/data/models/order.dart' as my_order;

class GiftRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GiftRepository();

  Future<List<GiftItem>> getGiftData() async {
    final querySnapshot = await _firestore.collection('gifts').get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.map((doc) {
        Gift gift = Gift.fromJson(doc.data());
        return GiftItem(gift: gift, productDocId: doc.id);
      }).toList();
    } else {
      throw Exception("No gifts found");
    }
  }

  Future<List<my_order.Order>> getOrderDataByUserDocId(String userDocId) async {
    final querySnapshot = await _firestore
        .collection('orders')
        .where('userDocId', isEqualTo: userDocId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.map((doc) {
        my_order.Order orders = my_order.Order.fromJson(doc.data());
        return orders;
      }).toList();
    } else {
      throw Exception("No orders found");
    }
  }

  Future<void> createOrder(
      String userDocId, String productDocId, int quantity, Gift gift) async {
    my_order.Order order = my_order.Order(
      userDocId: userDocId,
      productDocId: productDocId,
      quantity: quantity,
      timestamp: DateTime.now(),
      gift: gift,
    );

    await _firestore.collection('orders').add(order.toJson());
  }

  Future<void> cancelOrder(String orderDocId) async {
    await _firestore.collection('orders').doc(orderDocId).delete();
  }
}

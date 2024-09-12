import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_movie/data/models/gift.dart';

class GiftRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  GiftRepository();

  Future<List<Gift>> getGiftData() async {
    final querySnapshot = await _firestore.collection('gifts').get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs
          .map((doc) => Gift.fromJson(doc.data()))
          .toList();
    } else {
      throw Exception("No gifts found");
    }
  }
}

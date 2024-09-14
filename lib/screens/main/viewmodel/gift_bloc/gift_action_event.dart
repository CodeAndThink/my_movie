import 'package:my_movie/data/models/gift.dart';

abstract class GiftActionEvent {}

class FetchGiftOrder extends GiftActionEvent {
  final String userDocId;

  FetchGiftOrder(this.userDocId);
}

class CreateGiftOrder extends GiftActionEvent {
  final String userDocId;
  final String productDocId;
  final int quantity;
  final Gift gift;

  CreateGiftOrder(this.userDocId, this.productDocId, this.quantity, this.gift);
}

class CancelGiftOrder extends GiftActionEvent {
  final String orderDocId;

  CancelGiftOrder(this.orderDocId);
}

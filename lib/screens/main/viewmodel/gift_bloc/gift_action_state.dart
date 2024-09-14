import 'package:my_movie/data/models/order.dart' as my_order;

abstract class GiftActionState {}

class GiftActionInitial extends GiftActionState {}

class GiftActionLoading extends GiftActionState {}

class GiftActionSuccess extends GiftActionState {}

class GiftActionError extends GiftActionState {
  final String message;

  GiftActionError(this.message);
}

class OrderLoadedSuccess extends GiftActionState {
  final List<my_order.Order> listOrders;

  OrderLoadedSuccess(this.listOrders);
}

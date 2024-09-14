import 'package:my_movie/data/models/gift_item.dart';

abstract class GiftState {}

class GiftInitial extends GiftState {}

class GiftLoading extends GiftState {}

class GiftLoaded extends GiftState {
  final List<GiftItem> listGifts;

  GiftLoaded(this.listGifts);
}

class GiftError extends GiftState {
  final String message;

  GiftError(this.message);
}

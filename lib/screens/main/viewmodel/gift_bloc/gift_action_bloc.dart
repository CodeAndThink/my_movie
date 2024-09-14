import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/repository/gift_repository.dart';
import 'package:my_movie/screens/main/viewmodel/gift_bloc/gift_action_event.dart';
import 'package:my_movie/screens/main/viewmodel/gift_bloc/gift_action_state.dart';

class GiftActionBloc extends Bloc<GiftActionEvent, GiftActionState> {
  final GiftRepository _giftRepository;
  GiftActionBloc(this._giftRepository) : super(GiftActionInitial()) {
    on<FetchGiftOrder>(_onFetchGiftOrder);
    on<CreateGiftOrder>(_onCreateGiftOrder);
    on<CancelGiftOrder>(_onCancelGiftOrder);
  }

  Future<void> _onFetchGiftOrder(
      FetchGiftOrder event, Emitter<GiftActionState> emit) async {
    emit(GiftActionLoading());
    try {
      final orders =
          await _giftRepository.getOrderDataByUserDocId(event.userDocId);
      emit(OrderLoadedSuccess(orders));
    } catch (e) {
      emit(GiftActionError(e.toString()));
    }
  }

  Future<void> _onCreateGiftOrder(
      CreateGiftOrder event, Emitter<GiftActionState> emit) async {
    emit(GiftActionLoading());
    try {
      await _giftRepository.createOrder(
          event.userDocId, event.productDocId, event.quantity, event.gift);
      emit(GiftActionSuccess());
    } catch (e) {
      emit(GiftActionError(e.toString()));
    }
  }

  Future<void> _onCancelGiftOrder(
      CancelGiftOrder event, Emitter<GiftActionState> emit) async {
    emit(GiftActionLoading());
    try {
      await _giftRepository.cancelOrder(event.orderDocId);
      emit(GiftActionSuccess());
    } catch (e) {
      emit(GiftActionError(e.toString()));
    }
  }
}

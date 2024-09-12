import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/repository/gift_repository.dart';
import 'package:my_movie/screens/main/viewmodel/gift_bloc/gift_event.dart';
import 'package:my_movie/screens/main/viewmodel/gift_bloc/gift_state.dart';

class GiftBloc extends Bloc<GiftEvent, GiftState> {
  final GiftRepository _giftRepository;
  GiftBloc(this._giftRepository) : super(GiftInitial()) {
    on<FetchGiftData>(_onFetchGiftData);
  }

  Future<void> _onFetchGiftData(
      FetchGiftData event, Emitter<GiftState> emit) async {
    emit(GiftLoading());
    try {
      final gifts = await _giftRepository.getGiftData();
      emit(GiftLoaded(gifts));
    } catch (e) {
      emit(GiftError(e.toString()));
    }
  }
}

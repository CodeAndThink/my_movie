import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_movie/data/models/user.dart';
import 'package:my_movie/data/models/user_display_info.dart';
import 'package:my_movie/data/repository/auth_repository.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_event.dart';
import 'package:my_movie/screens/main/viewmodel/user_data_bloc/user_data_state.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  final AuthRepository _authRepository;

  UserDataBloc(this._authRepository) : super(UserDataInitial()) {
    on<FetchUserData>(_onFetchUserData);
    on<CreateUserData>(_onCreateUserData);
    on<UpdateUserData>(_onUpdateUserData);
    on<DeleteUserData>(_onDeleteUserData);
    on<UpdateFavorite>(_onUpdateFavorite);
    on<AuthUpdateProfilePicture>(_onUpdateProfilePicture);
    on<FetchUserDisplayInfo>(_onFetchUserDisplayInfo);
  }

  Future<void> _onFetchUserData(
      FetchUserData event, Emitter<UserDataState> emit) async {
    emit(UserDataLoading());
    try {
      final userData = await _authRepository.fetchUserData(event.userId);
      final user = User.fromJson(userData);
      emit(UserDataLoaded(user));
      
    } catch (e) {
      emit(UserDataFailure(e.toString()));
    }
  }

  Future<void> _onCreateUserData(
      CreateUserData event, Emitter<UserDataState> emit) async {
    try {
      await _authRepository.createUserData(event.userData);
      emit(UserDataCreated());
    } catch (e) {
      emit(UserDataFailure(e.toString()));
    }
  }

  Future<void> _onUpdateUserData(
      UpdateUserData event, Emitter<UserDataState> emit) async {
    try {
      await _authRepository.updateUserData(event.userId, event.updatedData);
      emit(UserDataUpdated());

    } catch (e) {
      emit(UserDataFailure(e.toString()));
    }
  }

  Future<void> _onUpdateFavorite(
      UpdateFavorite event, Emitter<UserDataState> emit) async {
    try {
      await _authRepository.updateFavorite(event.userId, event.movieId);
      emit(UserDataUpdated());
    } catch (e) {
      emit(UserDataFailure(e.toString()));
    }
  }

  Future<void> _onDeleteUserData(
      DeleteUserData event, Emitter<UserDataState> emit) async {
    try {
      await _authRepository.deleteUserData(event.userId);
      emit(UserDataDeleted());
    } catch (e) {
      emit(UserDataFailure(e.toString()));
    }
  }

  Future<void> _onUpdateProfilePicture(
      AuthUpdateProfilePicture event, Emitter<UserDataState> emit) async {
    try {
      await _authRepository.uploadImage(event.imageUrl);
      emit(UserDataUpdated());
    } catch (e) {
      emit(UserDataFailure(e.toString()));
    }
  }

  Future<void> _onFetchUserDisplayInfo(
      FetchUserDisplayInfo event, Emitter<UserDataState> emit) async {
    emit(UserDataLoading());
    try {
      final List<UserDisplayInfo> listDatas =
          await _authRepository.fetchListUserCommentData(event.listIds);
      emit(UserCommentDatasLoaded(listDatas));
    } catch (e) {
      emit(UserDataFailure(e.toString()));
    }
  }
}

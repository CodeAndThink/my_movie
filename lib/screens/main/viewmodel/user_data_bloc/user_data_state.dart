import 'package:my_movie/data/models/user_display_info.dart';

abstract class UserDataState {
  List<Object> get props => [];
}

class UserDataInitial extends UserDataState {}

class UserDataLoading extends UserDataState {}

class UserDataLoaded extends UserDataState {
  final Map<String, dynamic> userData;

  UserDataLoaded(this.userData);

  @override
  List<Object> get props => [userData];
}

class UserDataCreated extends UserDataState {}

class UserDataUpdated extends UserDataState {}

class UserDataDeleted extends UserDataState {}

class ProfilePictureUpdated extends UserDataState {
  final String avatarUrl;

  ProfilePictureUpdated(this.avatarUrl);

  @override
  List<Object> get props => [avatarUrl];
}

class UserDataFailure extends UserDataState {
  final String error;

  UserDataFailure(this.error);

  @override
  List<Object> get props => [error];
}

class UserCommentDatasLoaded extends UserDataState {
  final List<UserDisplayInfo> userCommentDatas;

  UserCommentDatasLoaded(this.userCommentDatas);
}

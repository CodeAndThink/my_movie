abstract class UserDataEvent {
  List<Object> get props => [];
}

class FetchUserData extends UserDataEvent {
  final String userId;

  FetchUserData(this.userId);

  @override
  List<Object> get props => [userId];
}

class CreateUserData extends UserDataEvent {
  final Map<String, dynamic> userData;

  CreateUserData(this.userData);

  @override
  List<Object> get props => [userData];
}

class UpdateUserData extends UserDataEvent {
  final String userId;
  final Map<String, dynamic> updatedData;

  UpdateUserData(this.userId, this.updatedData);

  @override
  List<Object> get props => [userId, updatedData];
}

class DeleteUserData extends UserDataEvent {
  final String userId;

  DeleteUserData(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateProfilePicture extends UserDataEvent {
  final String imagePath;

  UpdateProfilePicture(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class UpdateFavorite extends UserDataEvent {
  final String userId;
  final List<int> movieId;

  UpdateFavorite({required this.movieId, required this.userId});

  @override
  List<Object> get props => [userId];
}

class AuthUpdateProfilePicture extends UserDataEvent {
  final String imageUrl;

  AuthUpdateProfilePicture({required this.imageUrl});

  @override
  List<Object> get props => [imageUrl];
}

class FetchUserDisplayInfo extends UserDataEvent {
  final List<String> listIds;

  FetchUserDisplayInfo(this.listIds);
}

import 'package:image_picker/image_picker.dart';

abstract class ImageState {}

class AvatarInitial extends ImageState {}

class ImageSelected extends ImageState {
  final XFile image;

  ImageSelected(this.image);
}

class ImageError extends ImageState {
  final String message;

  ImageError(this.message);
}
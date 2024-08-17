import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_movie/screens/main/viewmodel/user_avatar_bloc/image_event.dart';
import 'package:my_movie/screens/main/viewmodel/user_avatar_bloc/image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImagePicker _picker = ImagePicker();

  ImageBloc() : super(AvatarInitial()) {
    on<PickImageFromCameraEvent>(_onPickImageFromCameraEvent);
    on<PickImageFromGalleryEvent>(_onPickImageFromGalleryEvent);
  }

  Future<void> _onPickImageFromCameraEvent(
      PickImageFromCameraEvent event, Emitter<ImageState> emit) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(ImageSelected(pickedFile));
    } else {
      emit(ImageError('No image selected from camera'));
    }
  }

  Future<void> _onPickImageFromGalleryEvent(
      PickImageFromGalleryEvent event, Emitter<ImageState> emit) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      emit(ImageSelected(pickedFile));
    } else {
      emit(ImageError('No image selected from gallery'));
    }
  }
}

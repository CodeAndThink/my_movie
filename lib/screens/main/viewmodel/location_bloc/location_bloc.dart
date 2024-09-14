import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_movie/data/repository/location_repository.dart';
import 'package:my_movie/screens/main/viewmodel/location_bloc/location_event.dart';
import 'package:my_movie/screens/main/viewmodel/location_bloc/location_state.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _locationRepository;

  LocationBloc(this._locationRepository) : super(GetLocationInitial()) {
    on<FetchCurrentLocation>(_onFetchCurrentLocation);
    on<RequestPermissionEvent>(_onRequestPermissionEvent);
  }

  Future<void> _onFetchCurrentLocation(
      FetchCurrentLocation event, Emitter<LocationState> emit) async {
    emit(GetLocationLoading());
    try {
      Position position = await _locationRepository.getCurrentPosition();

      emit(GetLocationLoaded(position));
    } catch (e) {
      emit(GetLocationError(e.toString()));
    }
  }

  Future<void> _onRequestPermissionEvent(
      RequestPermissionEvent event, Emitter<LocationState> emit) async {
    PermissionStatus status = await Permission.location.status;

    if (status.isGranted) {
      add(FetchCurrentLocation());
    } else if (status.isDenied) {
      final newStatus = await Permission.location.request();

      if (newStatus.isGranted) {
        add(FetchCurrentLocation());
      } else if (newStatus.isDenied) {
        emit(GetLocationError('Quyền bị từ chối.'));
      } else if (newStatus.isPermanentlyDenied) {
        emit(GetLocationError(
            'Quyền bị từ chối vĩnh viễn. Bạn cần vào cài đặt để cấp quyền.'));
      }
    } else if (status.isPermanentlyDenied) {
      emit(GetLocationError(
          'Quyền bị từ chối vĩnh viễn. Bạn cần vào cài đặt để cấp quyền.'));
      await openAppSettings();
    }
  }
}

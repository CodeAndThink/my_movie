import 'package:geolocator/geolocator.dart';

abstract class LocationState {}

class GetLocationInitial extends LocationState {}

class GetLocationLoading extends LocationState {}

class GetLocationLoaded extends LocationState {
  final Position position;

  GetLocationLoaded(this.position);
}

class GetLocationError extends LocationState {
  final String message;

  GetLocationError(this.message);
}

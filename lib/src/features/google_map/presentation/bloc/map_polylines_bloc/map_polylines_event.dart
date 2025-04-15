part of 'map_polylines_bloc.dart';

sealed class MapPolylinesEvent extends Equatable {
  const MapPolylinesEvent();

  @override
  List<Object?> get props => [];
}

class FetchPolylinePointsEvent extends MapPolylinesEvent {
  const FetchPolylinePointsEvent({
    required this.origin,
    required this.destination,
  });

  final PointLatLng origin;
  final PointLatLng destination;

  @override
  List<Object?> get props => [origin, destination];
}

class ClearPolylineEvent extends MapPolylinesEvent {
  const ClearPolylineEvent();
}

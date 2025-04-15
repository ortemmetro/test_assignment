part of 'map_polylines_bloc.dart';

sealed class MapPolylinesState extends Equatable {
  const MapPolylinesState();

  @override
  List<Object?> get props => [];
}

class MapPolylinesInitial extends MapPolylinesState {
  const MapPolylinesInitial();
}

class MapPolylinesLoading extends MapPolylinesState {
  const MapPolylinesLoading();
}

class MapPolylinesLoaded extends MapPolylinesState {
  const MapPolylinesLoaded({required this.polylines});

  final Map<PolylineId, Polyline> polylines;
}

class MapPolylinesError extends MapPolylinesState {
  const MapPolylinesError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

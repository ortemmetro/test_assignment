import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_application/src/features/google_map/domain/repositories/i_map_polylines_repository.dart';

part 'map_polylines_event.dart';
part 'map_polylines_state.dart';

class MapPolylinesBloc extends Bloc<MapPolylinesEvent, MapPolylinesState> {
  MapPolylinesBloc(this._mapPolylinesRepository)
    : super(const MapPolylinesInitial()) {
    on<MapPolylinesEvent>((event, emit) async {
      switch (event) {
        case FetchPolylinePointsEvent():
          await _fetchPolylinePoints(event, emit);
          break;
        case ClearPolylineEvent():
          emit(const MapPolylinesInitial());
          break;
      }
    });
  }

  final IMapPolylinesRepository _mapPolylinesRepository;

  Future<void> _fetchPolylinePoints(
    FetchPolylinePointsEvent event,
    Emitter<MapPolylinesState> emit,
  ) async {
    try {
      emit(const MapPolylinesLoading());
      final polylinePoints = await _mapPolylinesRepository.fetchPolylinePoints(
        origin: event.origin,
        destination: event.destination,
      );
      emit(
        MapPolylinesLoaded(
          polylines: <PolylineId, Polyline>{
            const PolylineId('polyline'): await _generatePolyLinesFromPoints(
              polylinePoints,
            ),
          },
        ),
      );
    } catch (e) {
      emit(const MapPolylinesError(message: 'Failed to fetch polyline points'));
    }
  }

  Future<Polyline> _generatePolyLinesFromPoints(
    List<LatLng> polylineCoordinate,
  ) async {
    const id = PolylineId('polyline');

    final polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      width: 5,
      points: polylineCoordinate,
    );

    return polyline;
  }
}

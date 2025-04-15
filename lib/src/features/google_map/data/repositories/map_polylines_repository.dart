import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_application/src/features/google_map/data/data_sources/map_polylines_data_source.dart';
import 'package:test_application/src/features/google_map/domain/repositories/i_map_polylines_repository.dart';

class MapPolylinesRepository implements IMapPolylinesRepository {
  MapPolylinesRepository(this._mapPolylinesDataSource);

  final MapPolylinesDataSource _mapPolylinesDataSource;

  @override
  Future<List<LatLng>> fetchPolylinePoints({
    required PointLatLng origin,
    required PointLatLng destination,
  }) async {
    try {
      return _mapPolylinesDataSource.fetchPolylinePoints(
        origin: origin,
        destination: destination,
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}

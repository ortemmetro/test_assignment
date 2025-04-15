import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class IMapPolylinesRepository {
  Future<List<LatLng>> fetchPolylinePoints({
    required PointLatLng origin,
    required PointLatLng destination,
  });
}

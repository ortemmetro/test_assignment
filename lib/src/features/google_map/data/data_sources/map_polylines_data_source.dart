import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_application/src/di/di.dart';

class MapPolylinesDataSource {
  Future<List<LatLng>> fetchPolylinePoints({
    required PointLatLng origin,
    required PointLatLng destination,
  }) async {
    final polylinePoints = PolylinePoints();
    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: getIt.get<String>(instanceName: 'google_map_api_key'),
      request: PolylineRequest(
        origin: origin,
        destination: destination,
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      debugPrint(result.errorMessage);
      return [];
    }
  }
}

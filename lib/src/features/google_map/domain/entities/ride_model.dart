import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideModel {
  final LatLng origin;
  final LatLng destination;
  final String originString;
  final String destinationString;
  final int passengersCount;
  final DateTime dateTime;

  const RideModel({
    required this.origin,
    required this.destination,
    required this.passengersCount,
    required this.dateTime,
    required this.originString,
    required this.destinationString,
  });

  factory RideModel.fromJson(Map<String, dynamic> json) {
    return RideModel(
      originString: json['originString'],
      destinationString: json['destinationString'],
      origin: LatLng(json['origin']['latitude'], json['origin']['longitude']),
      destination: LatLng(
        json['destination']['latitude'],
        json['destination']['longitude'],
      ),
      passengersCount: json['passengersCount'],
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'originString': originString,
      'destinationString': destinationString,
      'origin': {'latitude': origin.latitude, 'longitude': origin.longitude},
      'destination': {
        'latitude': destination.latitude,
        'longitude': destination.longitude,
      },
      'passengersCount': passengersCount,
      'dateTime': dateTime.toIso8601String(),
    };
  }
}

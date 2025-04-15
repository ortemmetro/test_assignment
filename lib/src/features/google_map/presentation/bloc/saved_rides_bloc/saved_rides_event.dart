part of 'saved_rides_bloc.dart';

sealed class SavedRidesEvent extends Equatable {
  const SavedRidesEvent();

  @override
  List<Object> get props => [];
}

class SaveRideEvent extends SavedRidesEvent {
  const SaveRideEvent({
    required this.originString,
    required this.destinationString,
    required this.passengersCount,
    required this.dateTime,
    required this.origin,
    required this.destination,
  });

  final LatLng origin;
  final LatLng destination;
  final String originString;
  final String destinationString;
  final int passengersCount;
  final DateTime dateTime;

  @override
  List<Object> get props => [
    origin,
    destination,
    passengersCount,
    dateTime,
    originString,
    destinationString,
  ];
}

class GetRidesEvent extends SavedRidesEvent {
  const GetRidesEvent();
}

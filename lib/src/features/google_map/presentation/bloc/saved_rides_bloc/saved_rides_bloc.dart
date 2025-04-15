import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_application/src/features/google_map/data/data_sources/local_data_source.dart';
import 'package:test_application/src/features/google_map/domain/entities/ride_model.dart';

part 'saved_rides_event.dart';
part 'saved_rides_state.dart';

class SavedRidesBloc extends Bloc<SavedRidesEvent, SavedRidesState> {
  SavedRidesBloc(this._localDataSource)
    : super(const SavedRidesInitial(rides: [])) {
    on<SavedRidesEvent>((event, emit) async {
      switch (event) {
        case SaveRideEvent():
          await saveRide(event, emit);
          break;
        case GetRidesEvent():
          await _getRides(event, emit);
          break;
        default:
      }
    });
  }

  final LocalDataSource _localDataSource;

  Future<void> saveRide(
    SaveRideEvent event,
    Emitter<SavedRidesState> emit,
  ) async {
    emit(SavedRidesLoading(rides: state.rides));

    final ride = RideModel(
      origin: event.origin,
      destination: event.destination,
      dateTime: event.dateTime,
      passengersCount: event.passengersCount,
      originString: event.originString,
      destinationString: event.destinationString,
    );
    final savedRides = await _localDataSource.getRides();
    final rideJson = jsonEncode(ride.toJson());

    await _localDataSource.saveRides(list: [...savedRides, rideJson]);

    emit(
      SavedRidesLoaded(
        rides:
            [
              ...savedRides,
              rideJson,
            ].map((e) => RideModel.fromJson(jsonDecode(e))).toList(),
      ),
    );
  }

  Future<void> _getRides(
    GetRidesEvent event,
    Emitter<SavedRidesState> emit,
  ) async {
    emit(SavedRidesLoading(rides: state.rides));

    final savedRides = await _localDataSource.getRides();

    final newRides =
        savedRides.map((e) {
          final rideMap = jsonDecode(e) as Map<String, dynamic>;
          return RideModel.fromJson(rideMap);
        }).toList();

    emit(SavedRidesLoaded(rides: newRides));
  }
}

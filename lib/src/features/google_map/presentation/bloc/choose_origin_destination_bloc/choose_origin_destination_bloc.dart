import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'choose_origin_destination_event.dart';
part 'choose_origin_destination_state.dart';

class ChooseOriginDestinationBloc
    extends Bloc<ChooseOriginDestinationEvent, ChooseOriginDestinationState> {
  ChooseOriginDestinationBloc()
    : super(
        const ChooseOriginDestinationInitial(
          origin: null,
          destination: null,
          originString: null,
          destinationString: null,
        ),
      ) {
    on<ChooseOriginDestinationEvent>((event, emit) async {
      switch (event) {
        case ChooseOriginEvent():
          await _chooseOrigin(event, emit);
          break;
        case ChooseDestinationEvent():
          await _chooseDestination(event, emit);
          break;
        case ChoosingOriginEvent():
          _choosingOrigin(event, emit);
          break;
        case ChoosingDestinationEvent():
          _choosingDestination(event, emit);
          break;
        case ClearEvent():
          _clear(event, emit);
          break;
        default:
      }
    });
  }

  void _clear(ClearEvent event, Emitter<ChooseOriginDestinationState> emit) {
    emit(
      const ChooseOriginDestinationInitial(
        origin: null,
        destination: null,
        originString: null,
        destinationString: null,
      ),
    );
  }

  void _choosingOrigin(
    ChoosingOriginEvent event,
    Emitter<ChooseOriginDestinationState> emit,
  ) {
    emit(
      ChooseOriginState(
        origin: state.origin,
        destination: state.destination,
        originString: state.originString,
        destinationString: state.destinationString,
      ),
    );
  }

  void _choosingDestination(
    ChoosingDestinationEvent event,
    Emitter<ChooseOriginDestinationState> emit,
  ) {
    emit(
      ChooseDestinationState(
        origin: state.origin,
        destination: state.destination,
        originString: state.originString,
        destinationString: state.destinationString,
      ),
    );
  }

  Future<void> _chooseOrigin(
    ChooseOriginEvent event,
    Emitter<ChooseOriginDestinationState> emit,
  ) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      event.origin.latitude,
      event.origin.longitude,
    );

    if (placemarks.isNotEmpty) {
      final Placemark place = placemarks.first;
      emit(
        ChooseOriginDestinationInitial(
          origin: event.origin,
          destination: state.destination,
          originString:
              '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}',
          destinationString: state.destinationString,
        ),
      );
      return;
    } else {
      emit(
        ChooseOriginDestinationInitial(
          origin: event.origin,
          destination: state.destination,
          originString: 'No address available',
          destinationString: state.destinationString,
        ),
      );
    }
  }

  Future<void> _chooseDestination(
    ChooseDestinationEvent event,
    Emitter<ChooseOriginDestinationState> emit,
  ) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      event.destination.latitude,
      event.destination.longitude,
    );

    if (placemarks.isNotEmpty) {
      final Placemark place = placemarks.first;
      emit(
        ChooseOriginDestinationInitial(
          origin: state.origin,
          destination: event.destination,
          originString: state.originString,
          destinationString:
              '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}',
        ),
      );
      return;
    } else {
      emit(
        ChooseOriginDestinationInitial(
          origin: state.origin,
          destination: event.destination,
          originString: 'No address available',
          destinationString: state.destinationString,
        ),
      );
    }
  }
}

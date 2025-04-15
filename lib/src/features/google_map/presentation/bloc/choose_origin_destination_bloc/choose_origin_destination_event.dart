part of 'choose_origin_destination_bloc.dart';

sealed class ChooseOriginDestinationEvent extends Equatable {
  const ChooseOriginDestinationEvent();

  @override
  List<Object> get props => [];
}

final class ChooseOriginEvent extends ChooseOriginDestinationEvent {
  const ChooseOriginEvent({required this.origin});

  final LatLng origin;

  @override
  List<Object> get props => [origin];
}

final class ChooseDestinationEvent extends ChooseOriginDestinationEvent {
  const ChooseDestinationEvent({required this.destination});

  final LatLng destination;

  @override
  List<Object> get props => [destination];
}

final class ChoosingDestinationEvent extends ChooseOriginDestinationEvent {
  const ChoosingDestinationEvent();
}

final class ChoosingOriginEvent extends ChooseOriginDestinationEvent {
  const ChoosingOriginEvent();
}

final class ClearEvent extends ChooseOriginDestinationEvent {
  const ClearEvent();
}

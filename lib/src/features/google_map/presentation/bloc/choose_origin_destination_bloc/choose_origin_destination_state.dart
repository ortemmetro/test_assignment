part of 'choose_origin_destination_bloc.dart';

sealed class ChooseOriginDestinationState extends Equatable {
  const ChooseOriginDestinationState({
    required this.origin,
    required this.destination,
    required this.originString,
    required this.destinationString,
  });

  final LatLng? origin;
  final LatLng? destination;
  final String? originString;
  final String? destinationString;

  @override
  List<Object?> get props => [
    origin,
    destination,
    originString,
    destinationString,
  ];
}

final class ChooseOriginDestinationInitial
    extends ChooseOriginDestinationState {
  const ChooseOriginDestinationInitial({
    required super.origin,
    required super.destination,
    required super.originString,
    required super.destinationString,
  });
}

final class ChooseOriginState extends ChooseOriginDestinationState {
  const ChooseOriginState({
    required super.origin,
    required super.destination,
    required super.originString,
    required super.destinationString,
  });
}

final class ChooseDestinationState extends ChooseOriginDestinationState {
  const ChooseDestinationState({
    required super.origin,
    required super.destination,
    required super.originString,
    required super.destinationString,
  });
}

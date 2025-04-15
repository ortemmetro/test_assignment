part of 'saved_rides_bloc.dart';

sealed class SavedRidesState extends Equatable {
  const SavedRidesState({required this.rides});

  final List<RideModel> rides;

  @override
  List<Object> get props => [rides];
}

final class SavedRidesInitial extends SavedRidesState {
  const SavedRidesInitial({required super.rides});
}

final class SavedRidesLoading extends SavedRidesState {
  const SavedRidesLoading({required super.rides});
}

final class SavedRidesLoaded extends SavedRidesState {
  const SavedRidesLoaded({required super.rides});
}

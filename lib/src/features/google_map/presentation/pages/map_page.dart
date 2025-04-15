import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import 'package:test_application/src/features/google_map/presentation/bloc/choose_origin_destination_bloc/choose_origin_destination_bloc.dart';
import 'package:test_application/src/features/google_map/presentation/bloc/map_polylines_bloc/map_polylines_bloc.dart';
import 'package:test_application/src/features/google_map/presentation/bloc/saved_rides_bloc/saved_rides_bloc.dart';
import 'package:test_application/src/features/google_map/presentation/widgets/bottom_sheet_header.dart';
import 'package:test_application/src/features/google_map/presentation/widgets/default_text_field.dart';
import 'package:test_application/src/features/google_map/presentation/widgets/google_map_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final locationController = Location();
  StreamSubscription<LocationData>? _locationSubscription;

  LatLng? currentPosition;
  LatLng? _centerPosition;
  BitmapDescriptor? markerIcon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initializeMap();
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<BitmapDescriptor> addCustomIcon() async {
    try {
      final asset = await rootBundle.load(
        'assets/icons/pngs/pin-location-icon.png',
      );
      final icon = BitmapDescriptor.bytes(
        asset.buffer.asUint8List(),
        width: 30,
        height: 30,
      );
      return icon;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<void> initializeMap() async {
    await fetchLocationUpdates();
    final marker = await addCustomIcon();
    setState(() {
      markerIcon = marker;
    });
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription = locationController.onLocationChanged.listen((
      currentLocation,
    ) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });

        debugPrint(currentPosition!.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<
        ChooseOriginDestinationBloc,
        ChooseOriginDestinationState
      >(
        listener: (context, state) {
          final bool isChoosingState =
              state is ChooseOriginState || state is ChooseDestinationState;
          if (state.destination != null &&
              state.origin != null &&
              !isChoosingState) {
            context.read<MapPolylinesBloc>().add(
              FetchPolylinePointsEvent(
                origin: PointLatLng(
                  state.origin!.latitude,
                  state.origin!.longitude,
                ),
                destination: PointLatLng(
                  state.destination!.latitude,
                  state.destination!.longitude,
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final bool isChoosingState =
              state is ChooseOriginState || state is ChooseDestinationState;

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child:
                    currentPosition == null
                        ? const Center(
                          child: CircularProgressIndicator.adaptive(),
                        )
                        : BlocBuilder<MapPolylinesBloc, MapPolylinesState>(
                          builder: (context, state) {
                            return GoogleMapWidget(
                              currentPosition: currentPosition,
                              markerIcon: markerIcon,
                              polylines:
                                  state is MapPolylinesLoaded
                                      ? state.polylines
                                      : {},
                              onMapMove: (position) {
                                _centerPosition = position;
                              },
                            );
                          },
                        ),
              ),
              isChoosingState
                  ? const Center(
                    child: Icon(
                      Icons.location_pin,
                      size: 40,
                      color: Colors.red,
                    ),
                  )
                  : const SizedBox.shrink(),
              Positioned.fill(
                child: BottomSheetWiget(
                  isChoosingState: isChoosingState,
                  centerPosition:
                      _centerPosition ??
                      LatLng(
                        currentPosition?.latitude ?? 0.0,
                        currentPosition?.longitude ?? 0.0,
                      ),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                child: SafeArea(
                  child: GestureDetector(
                    onTap: () {
                      context.read<ChooseOriginDestinationBloc>().add(
                        const ClearEvent(),
                      );
                      context.read<MapPolylinesBloc>().add(
                        const ClearPolylineEvent(),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(child: Icon(Icons.chevron_left)),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class BottomSheetWiget extends StatefulWidget {
  const BottomSheetWiget({
    required this.isChoosingState,
    required this.centerPosition,
    super.key,
  });

  final bool isChoosingState;
  final LatLng centerPosition;

  @override
  State<BottomSheetWiget> createState() => _BottomSheetWigetState();
}

class _BottomSheetWigetState extends State<BottomSheetWiget> {
  final TextEditingController passengersCountController =
      TextEditingController();

  DateTime? dateTime;

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      ChooseOriginDestinationBloc,
      ChooseOriginDestinationState
    >(
      builder: (context, state) {
        final isButtonEnabled =
            state.origin != null &&
            state.destination != null &&
            passengersCountController.text.isNotEmpty &&
            dateTime != null;
        return LayoutBuilder(
          builder: (context, constraints) {
            final parentHeight = constraints.maxHeight;
            final appbarHeight = MediaQuery.of(context).padding.top;
            const handleHeight = 140;
            final sheetHeight = parentHeight - appbarHeight + handleHeight;
            final minSheetOffset = SheetOffset.absolute(
              handleHeight + MediaQuery.of(context).padding.bottom,
            );
            return SafeArea(
              child: SheetViewport(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Sheet(
                  scrollConfiguration: const SheetScrollConfiguration(),
                  initialOffset: const SheetOffset(0.5),
                  snapGrid: SheetSnapGrid(
                    snaps: [
                      minSheetOffset,
                      const SheetOffset(1),
                      const SheetOffset(0.4),
                    ],
                  ),
                  decoration: const MaterialSheetDecoration(
                    size: SheetSize.stretch,
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight:
                          widget.isChoosingState
                              ? handleHeight +
                                  MediaQuery.of(context).padding.bottom +
                                  110
                              : MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: Column(
                      children: [
                        BottomSheetHeader(
                          isSelecting: widget.isChoosingState,
                          selectText:
                              state is ChooseOriginState
                                  ? 'Select pickup location'
                                  : 'Select destination location',
                          onSelectTap: () {
                            if (state is ChooseOriginState) {
                              context.read<ChooseOriginDestinationBloc>().add(
                                ChooseOriginEvent(
                                  origin: widget.centerPosition,
                                ),
                              );
                            } else if (state is ChooseDestinationState) {
                              context.read<ChooseOriginDestinationBloc>().add(
                                ChooseDestinationEvent(
                                  destination: widget.centerPosition,
                                ),
                              );
                            }
                          },
                        ),
                        widget.isChoosingState
                            ? const SizedBox.shrink()
                            : Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  children: [
                                    DefaultTextField(
                                      readOnly: true,
                                      hintText:
                                          state.origin != null
                                              ? state.originString!
                                              : 'Pickup location',
                                      prefix: Image.asset(
                                        'assets/icons/pngs/start_icon.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                      onTap: () {
                                        context
                                            .read<ChooseOriginDestinationBloc>()
                                            .add(const ChoosingOriginEvent());
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    DefaultTextField(
                                      readOnly: true,
                                      hintText:
                                          state.destination != null
                                              ? state.destinationString!
                                              : 'Destination location',
                                      prefix: Image.asset(
                                        'assets/icons/pngs/finish_icon.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                      onTap: () {
                                        context
                                            .read<ChooseOriginDestinationBloc>()
                                            .add(
                                              const ChoosingDestinationEvent(),
                                            );
                                      },
                                    ),

                                    const SizedBox(height: 8),
                                    DefaultTextField(
                                      hintText: 'Passengers Count',
                                      controller: passengersCountController,
                                      keyboardType: TextInputType.number,
                                      prefix: const Icon(
                                        Icons.person,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    DefaultTextField(
                                      hintText:
                                          dateTime != null
                                              ? DateFormat(
                                                'yyyy-MM-dd – hh:mm a',
                                              ).format(dateTime!)
                                              : 'Date and Time',
                                      readOnly: true,
                                      onTap: () {
                                        showDateTimePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2100),
                                        ).then((value) {
                                          if (value != null) {
                                            dateTime = value;
                                            debugPrint(value.toString());
                                          }
                                        });
                                      },
                                      prefix: const Icon(
                                        Icons.calendar_today,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed:
                                            !isButtonEnabled
                                                ? null
                                                : () {
                                                  context.read<SavedRidesBloc>().add(
                                                    SaveRideEvent(
                                                      passengersCount:
                                                          int.tryParse(
                                                            passengersCountController
                                                                .text,
                                                          )!,
                                                      dateTime: dateTime!,
                                                      origin: state.origin!,
                                                      destination:
                                                          state.destination!,
                                                      originString:
                                                          state.originString!,
                                                      destinationString:
                                                          state
                                                              .destinationString!,
                                                    ),
                                                  );
                                                  context
                                                      .read<
                                                        ChooseOriginDestinationBloc
                                                      >()
                                                      .add(const ClearEvent());
                                                  context
                                                      .read<MapPolylinesBloc>()
                                                      .add(
                                                        const ClearPolylineEvent(),
                                                      );
                                                  Navigator.of(context).pop();
                                                },
                                        child: const Text('Book the ride'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

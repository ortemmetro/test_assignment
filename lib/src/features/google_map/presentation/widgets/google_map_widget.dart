import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_application/src/features/google_map/presentation/bloc/choose_origin_destination_bloc/choose_origin_destination_bloc.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({
    required this.currentPosition,
    required this.markerIcon,
    required this.polylines,
    super.key,
    this.onMapMove,
    this.onMapIdle,
  });

  final LatLng? currentPosition;
  final BitmapDescriptor? markerIcon;
  final Map<PolylineId, Polyline> polylines;
  final void Function(LatLng)? onMapMove;
  final void Function()? onMapIdle;

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  late final GoogleMapController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      ChooseOriginDestinationBloc,
      ChooseOriginDestinationState
    >(
      builder: (context, state) {
        return GoogleMap(
          onMapCreated: (controller) {
            _controller = controller;
          },
          initialCameraPosition: CameraPosition(
            target: widget.currentPosition!,
            zoom: 13,
          ),
          onCameraMove: (position) {
            if (widget.onMapMove != null) {
              widget.onMapMove!(position.target);
            }
          },
          onCameraIdle: () {
            if (widget.onMapIdle != null) {
              widget.onMapIdle?.call();
            }
          },
          markers: {
            Marker(
              markerId: const MarkerId('currentLocation'),
              icon:
                  widget.markerIcon != null
                      ? widget.markerIcon!
                      : BitmapDescriptor.defaultMarker,
              position: widget.currentPosition!,
            ),
            state.origin != null
                ? Marker(
                  markerId: const MarkerId('originLocation'),
                  icon:
                      widget.markerIcon != null
                          ? widget.markerIcon!
                          : BitmapDescriptor.defaultMarker,
                  position: state.origin!,
                )
                : const Marker(markerId: MarkerId('')),

            state.destination != null
                ? Marker(
                  markerId: const MarkerId('destinationLocation'),
                  icon:
                      widget.markerIcon != null
                          ? widget.markerIcon!
                          : BitmapDescriptor.defaultMarker,
                  position: state.destination!,
                )
                : const Marker(markerId: MarkerId('')),
            // Marker(
            //   markerId: const MarkerId('sourceLocation'),
            //   icon: BitmapDescriptor.defaultMarker,
            //   position: googlePlex,
            // ),
            // Marker(
            //   markerId: const MarkerId('destinationLocation'),
            //   icon: BitmapDescriptor.defaultMarker,
            //   position: mountainView,
            // ),
          },
          polylines: Set<Polyline>.of(widget.polylines.values),
        );
      },
    );
  }
}

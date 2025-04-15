import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:test_application/src/common/extensions/context_extension.dart';
import 'package:test_application/src/di/di.dart';
import 'package:test_application/src/di/get_it_provider.dart';
import 'package:test_application/src/features/google_map/presentation/bloc/choose_origin_destination_bloc/choose_origin_destination_bloc.dart';
import 'package:test_application/src/features/google_map/presentation/bloc/map_polylines_bloc/map_polylines_bloc.dart';
import 'package:test_application/src/features/google_map/presentation/bloc/saved_rides_bloc/saved_rides_bloc.dart';
import 'package:test_application/src/features/google_map/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencyInjection();

  runApp(const RideBookingApp());
}

class RideBookingApp extends StatelessWidget {
  const RideBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        Provider.value(value: GetItProvider(getIt: getIt)),
        BlocProvider(create: (context) => context.get<MapPolylinesBloc>()),
        BlocProvider(
          create: (context) => context.get<ChooseOriginDestinationBloc>(),
        ),
        BlocProvider(create: (context) => context.get<SavedRidesBloc>()),
      ],
      child: MaterialApp(
        title: 'Ride Booking App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      ),
    );
  }
}

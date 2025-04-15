import 'package:get_it/get_it.dart';
import 'package:test_application/src/features/google_map/data/data_sources/local_data_source.dart';
import 'package:test_application/src/features/google_map/domain/repositories/i_map_polylines_repository.dart';
import 'package:test_application/src/features/google_map/presentation/bloc/choose_origin_destination_bloc/choose_origin_destination_bloc.dart';
import 'package:test_application/src/features/google_map/presentation/bloc/map_polylines_bloc/map_polylines_bloc.dart';
import 'package:test_application/src/features/google_map/presentation/bloc/saved_rides_bloc/saved_rides_bloc.dart';

abstract class BlocsModule {
  static Future<void> registerInstances(GetIt getIt) async {
    getIt.registerSingleton<MapPolylinesBloc>(
      MapPolylinesBloc(getIt<IMapPolylinesRepository>()),
    );

    getIt.registerSingleton<ChooseOriginDestinationBloc>(
      ChooseOriginDestinationBloc(),
    );

    getIt.registerSingleton<SavedRidesBloc>(
      SavedRidesBloc(getIt<LocalDataSource>()),
    );
  }
}

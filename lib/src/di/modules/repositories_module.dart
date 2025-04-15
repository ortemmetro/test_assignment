import 'package:get_it/get_it.dart';
import 'package:test_application/src/features/google_map/data/data_sources/map_polylines_data_source.dart';
import 'package:test_application/src/features/google_map/data/repositories/map_polylines_repository.dart';
import 'package:test_application/src/features/google_map/domain/repositories/i_map_polylines_repository.dart';

abstract class RepositoriesModule {
  static Future<void> registerInstances(GetIt getIt) async {
    getIt.registerSingleton<IMapPolylinesRepository>(
      MapPolylinesRepository(getIt<MapPolylinesDataSource>()),
    );
  }
}

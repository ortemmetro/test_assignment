/*Модуль для регистрации всех datasource, используемых в приложении
*/

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_application/src/features/google_map/data/data_sources/local_data_source.dart';
import 'package:test_application/src/features/google_map/data/data_sources/map_polylines_data_source.dart';

abstract class DataSourceModule {
  static Future<void> registerInstances(GetIt getIt) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(sharedPreferences);

    getIt.registerSingleton(MapPolylinesDataSource());

    getIt.registerSingleton<LocalDataSource>(
      LocalDataSource(getIt<SharedPreferences>()),
    );
  }
}

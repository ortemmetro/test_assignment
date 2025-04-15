import 'package:get_it/get_it.dart';

abstract class ConstantsModule {
  static Future<void> registerInstances(GetIt getIt) async {
    getIt.registerFactory<String>(
      () =>
          'insert_here_your_google_maps_api_key', // Insert your Google Maps API key here
      instanceName: 'google_map_api_key',
    );
  }
}

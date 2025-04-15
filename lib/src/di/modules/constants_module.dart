import 'package:get_it/get_it.dart';

abstract class ConstantsModule {
  static Future<void> registerInstances(GetIt getIt) async {
    getIt.registerFactory<String>(
      () => 'AIzaSyA76nsmDXvYl3xd_3EUEIqwyNigOj-9w_M',
      instanceName: 'google_map_api_key',
    );
  }
}

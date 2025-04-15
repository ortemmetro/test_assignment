part of './di.dart';

final getIt = GetIt.instance;

Future<void> configureDependencyInjection() async {
  await _registerModules();
}

Future<void> _registerModules() async {
  ConstantsModule.registerInstances(getIt);
  await DataSourceModule.registerInstances(getIt);
  RepositoriesModule.registerInstances(getIt);
  await BlocsModule.registerInstances(getIt);
}

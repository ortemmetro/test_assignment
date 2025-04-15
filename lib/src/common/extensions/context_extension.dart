import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_application/src/di/get_it_provider.dart';

extension ContextExtension on BuildContext {
  T get<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) => read<GetItProvider>().getIt<T>(
    param1: param1,
    param2: param2,
    instanceName: instanceName,
  );
}

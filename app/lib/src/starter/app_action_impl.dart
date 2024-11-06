import 'package:app/src/di/inject.dart' as app;
import 'package:app/src/features/chat/bloc/session_cubit.dart';
import 'package:app/src/features/settings/bloc/app_config_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:initializer/initializer.dart';
import 'package:shared/shared.dart';
import 'package:data/data.dart' as data;
import 'package:domain/domain.dart' as domain;

import '../config/app_config.dart';

class AppStartActionImpl extends AppStartAction<AppConfig> {
  const AppStartActionImpl();

  @override
  Future<void> onInject() async {
    String environment = 'prod';
    await domain.configureDependencies(environment: environment);
    await data.configureDependencies(environment: environment);
    await app.configureDependencies(environment: environment);
  }

  @override
  void onError(BuildContext context, String message) {}

  @override
  void onLoaded(BuildContext context, AppConfig data) async {
    context.read<AppConfigBloc>().init(data);
    await getIt<SessionCubit>().loadSessions();
  }

  @override
  void onSuccess(BuildContext context) {}
}

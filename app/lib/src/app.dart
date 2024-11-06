import 'dart:async';

import 'package:app/src/config/app_config.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:initializer/initializer.dart';
import 'package:shared/shared.dart';

import 'starter/app_action_impl.dart';
import 'starter/app_bloc_providers.dart';
import 'starter/app_start_repository_impl.dart';

class Application {
  void run(List<String> args) {
    runZonedGuarded(_runApp, onGlobalError);
  }

  void _runApp() {
    WidgetsFlutterBinding.ensureInitialized();
    runApp(
      const StartScope<AppConfig>(
        repository: AppStartRepositoryImpl(),
        action: AppStartActionImpl(),
        child: AppBlocProviders(),
      ),
    );
    initWindow();
  }

  void onGlobalError(Object error, StackTrace stack) {}

  void initWindow() {
    if (isDesktop()) {
      doWhenWindowReady(() {
        const initialSize = Size(1000, 700);
        appWindow.minSize = initialSize;
        appWindow.size = initialSize;
        appWindow.alignment = Alignment.center;
        appWindow.show();
      });
    }
  }
}

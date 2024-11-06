import 'package:app/src/features/chat/bloc/session_cubit.dart';
import 'package:app/src/features/settings/bloc/app_config_bloc.dart';
import 'package:app/src/router/router.dart';
import 'package:app/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:initializer/initializer.dart';
import 'package:resources/resources.dart';
import 'package:shared/shared.dart';

class AppBlocProviders extends StatelessWidget {
  const AppBlocProviders({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<AppConfigBloc>()),
          BlocProvider(create: (context) => getIt<SessionCubit>())
        ],
        child: AppStartListener(
          child: Builder(builder: (context) {
            final appConfig = context.watch<AppConfigBloc>().state;
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'ThinkGPT',
              theme: lightThemeData,
              darkTheme: darkThemeData,
              themeMode: appConfig.themeMode,
              localizationsDelegates: const [
                IntlUtils.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: IntlUtils.delegate.supportedLocales,
              locale: Locale(appConfig.language),
              routerConfig: router,
            );
          }),
        ));
  }
}

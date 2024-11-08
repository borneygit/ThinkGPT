import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';

import 'app_start_bloc.dart';

class AppStartListener extends StatelessWidget {
  final Widget child;

  const AppStartListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppStartBloc, AppStatus>(
      listener: (context, state) {
        performAction(state, context);
      },
      builder: (BuildContext context, AppStatus<dynamic> state) {
        return buildWidget(state);
      },
    );
  }

  void performAction(AppStatus<dynamic> state, BuildContext context) {
    final action = context.read<AppStartBloc>().action;
    state.maybeWhen(
        starting: () {},
        done: (data) {
          action.onLoaded(context, data);
        },
        success: (dur) {
          action.onSuccess(context);
        },
        failed: (e) {
          Log.e(e);
          action.onError(context, e.toString());
        },
        orElse: () {});
  }

  Widget buildWidget(AppStatus<dynamic> state) {
    return state.maybeWhen(
        success: (_) => child,
        failed: (e) => Center(child: Text('Error: $e')),
        orElse: () {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        });
  }
}

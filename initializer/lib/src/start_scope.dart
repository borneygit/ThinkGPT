import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_start_action.dart';
import 'app_start_bloc.dart';
import 'app_start_repository.dart';

class StartScope<T> extends StatelessWidget {
  final Widget child;
  final AppStartRepository<T> repository;
  final AppStartAction<T> action;

  const StartScope({
    super.key,
    required this.repository,
    required this.action,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppStartBloc>(
      lazy: false,
      create: (context) =>
          AppStartBloc(repository: repository, action: action)..init(),
      child: child,
    );
  }
}

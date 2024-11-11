import 'package:app/src/core/sessionx.dart';
import 'package:app/src/features/chat/bloc/session_cubit.dart';
import 'package:app/src/features/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resources/resources.dart';

final commands = [
  Command(
      command: '/settings',
      description: (context) => IntlUtils.of(context).open_settings,
      action: (context, args) {
        showSettings(context);
      }),
  Command(
      command: '/model',
      description: (context) => IntlUtils.of(context).change_model,
      needArgs: true,
      action: (context, args) async {
        final model = args?.first;
        if (model != null) {
          final bloc = context.read<SessionCubit>();
          var active = bloc.state.activeSession;
          if (active != null) {
            await bloc.upsertSession(active.copyWith(model: model));
          } else {
            final session = SessionX.createSession('', model);
            active = await bloc.upsertSession(session);
            await bloc.setActiveSession(active);
          }
        }
      }),
];

class Command {
  final String command;
  final String Function(BuildContext) description;
  final bool needArgs;
  final Function(BuildContext context, List<String>? args) action;

  Command({
    required this.command,
    required this.description,
    required this.action,
    this.needArgs = false,
  });

  @override
  toString() => '$command: $description';
}

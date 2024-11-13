import 'package:app/src/features/chat/bloc/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat_history_item.dart';

class ChatHistoryWindow extends StatelessWidget {
  const ChatHistoryWindow({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 200,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: colorScheme.secondary,
        ),
        child: BlocBuilder<SessionCubit, SessionState>(
          builder: (BuildContext context, SessionState state) {
            return ListView.separated(
              itemBuilder: (context, index) {
                final isActive =
                    state.sessions[index].id == state.activeSession?.id;
                return ChatHistoryItem(
                  key: ValueKey(state.sessions[index].id),
                  session: state.sessions[index],
                  isActive: isActive,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 2),
              itemCount: state.sessions.length,
            );
          },
        ),
      ),
    );
  }
}

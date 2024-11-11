import 'package:app/src/features/chat/bloc/messages_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'received_message_widget.dart';
import 'send_message_widget.dart';

class ChatMessageList extends HookWidget {
  const ChatMessageList({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    void scrollToBottom() {
      if (!scrollController.hasClients ||
          !scrollController.position.hasViewportDimension) {
        return;
      }
      try {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      } catch (_) {}
    }

    return BlocConsumer<MessageCubit, MessageState>(
      listener: (BuildContext context, MessageState state) {
        if (state.messages.isEmpty) {
          return;
        }
        if (context.mounted) {
          Future.delayed(const Duration(milliseconds: 50), () {
            scrollToBottom();
          });
        }
      },
      builder: (context, state) {
        return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            controller: scrollController,
            itemBuilder: (context, index) {
              final message = state.messages[index];
              if (message.isUser) {
                return SendMessageWidget(
                  message: message,
                  key: ValueKey(message.id),
                );
              } else {
                return ReceivedMessageWidget(
                  message: message,
                  key: ValueKey(message.id),
                );
              }
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: 12,
              );
            },
            itemCount: state.messages.length);
      },
    );
  }
}

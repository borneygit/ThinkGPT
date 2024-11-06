import 'package:app/src/features/chat/bloc/messages_cubit.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:resources/resources.dart';

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

class SendMessageWidget extends StatelessWidget {
  final Message message;

  const SendMessageWidget({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            margin: const EdgeInsets.only(left: 48, right: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: colorScheme.secondary,
            ),
            child: MessageContentWidget(message: message),
          ),
        ),
      ],
    );
  }
}

class ReceivedMessageWidget extends StatelessWidget {
  final Message message;

  const ReceivedMessageWidget({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          padding: const EdgeInsets.all(6),
          margin: const EdgeInsets.only(left: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              width: 1, // 边框宽度
              color: colorScheme.secondaryContainer, // 边框颜色
            ),
          ),
          child: SvgPicture.asset(
            Images.chatgpt,
            colorFilter:
                ColorFilter.mode(colorScheme.onPrimary, BlendMode.srcIn),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            margin: const EdgeInsets.only(right: 48),
            child: MessageContentWidget(message: message),
          ),
        ),
      ],
    );
  }
}

class MessageContentWidget extends StatelessWidget {
  final Message message;
  final bool typing;

  const MessageContentWidget(
      {super.key, required this.message, this.typing = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TexMarkdown(
          message.content,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

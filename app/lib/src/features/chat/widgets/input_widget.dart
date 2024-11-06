import 'dart:math';

import 'package:app/src/core/base/widget/circle_inkwell.dart';
import 'package:app/src/features/chat/bloc/message_send_bloc.dart';
import 'package:app/src/features/chat/bloc/session_cubit.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:resources/resources.dart';
import 'package:shared/shared.dart';
import 'package:uuid/uuid.dart';

class InputWidget extends HookWidget {
  const InputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();
    final hasText = useState(false);
    final focusNode = useFocusNode();
    final colorScheme = Theme.of(context).colorScheme;

    useEffect(() {
      void listener() {
        hasText.value = textEditingController.text.isNotEmpty;
      }

      textEditingController.addListener(listener);
      return () {
        textEditingController.removeListener(listener);
      };
    }, [textEditingController]);

    final state = context.watch<MessageSenderBloc>().state;

    sendMessage() {
      if (state is! Sending) {
        _sendMessage(context, textEditingController.text);
        textEditingController.clear();
        FocusScope.of(context).requestFocus(focusNode);
      }
    }

    return Container(
        margin: const EdgeInsets.only(right: 56, left: 56, bottom: 24),
        decoration: BoxDecoration(
            color: colorScheme.secondary,
            borderRadius: BorderRadius.circular(200)),
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Row(
          children: [
            CircleInkWell(
              child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedAdd01, color: Colors.grey),
              onTap: () {},
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: TextField(
                  maxLines: 3,
                  minLines: 1,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  focusNode: focusNode,
                  cursorColor: colorScheme.onSecondary,
                  cursorHeight: 18,
                  cursorWidth: 2,
                  cursorRadius: const Radius.circular(2),
                  controller: textEditingController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: IntlUtils.of(context).gptInputHint,
                    hintStyle: const TextStyle(
                      color: Colors.grey, // 设置提示文字颜色
                      fontSize: 16, // 可选：设置提示文字大小
                    ),
                  ),
                  onSubmitted: (text) {
                    sendMessage();
                  }),
            ),
            const SizedBox(
              width: 8,
            ),
            CircleInkWell(
              child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedMic01, color: Colors.grey),
              onTap: () {},
            ),
            if (state is Sending) ...[
              const SizedBox(
                width: 8,
              ),
              StopWidget(onTap: () {
                context
                    .read<MessageSenderBloc>()
                    .add(const MessageSendEvent.stopSending());
              })
            ] else ...[
              if (hasText.value) ...[
                const SizedBox(
                  width: 8,
                ),
                SendWidget(
                  onTap: () {
                    sendMessage();
                  },
                ),
              ],
            ]
          ],
        ));
  }

  void _sendMessage(BuildContext context, String text) async {
    final sessionCubit = context.read<SessionCubit>();
    final messageSenderBloc = context.read<MessageSenderBloc>();
    var active = sessionCubit.state.activeSession;
    var sessionId = active?.id ?? '';
    if (sessionId.isEmpty) {
      final now = DateTime.now();
      final session = Session(
          id: getIt<Uuid>().v4(),
          title: text,
          model: 'claude-3-5-sonnet-20241022',
          type: 0,
          createdAt: now,
          updatedAt: now);
      active = await sessionCubit.upsertSession(session);
      await sessionCubit.setActiveSession(active);
      sessionId = active.id;
    }
    final message = _createMessage(text, isUser: true, sessionId: sessionId);
    messageSenderBloc.add(MessageSendEvent.sendMessage(
        message.copyWith(sessionId: sessionId), active!));
  }

  Message _createMessage(String content,
      {String? id, bool isUser = true, required String sessionId}) {
    final message = Message(
      id: id ?? getIt<Uuid>().v4(),
      content: content,
      isUser: isUser,
      timestamp: DateTime.now(),
      sessionId: sessionId,
    );
    return message;
  }
}

class SendWidget extends StatelessWidget {
  final GestureTapCallback? onTap;

  const SendWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Transform.rotate(
          angle: pi / 2,
          child: const Icon(size: 36, Icons.arrow_circle_left_sharp)),
    );
  }
}

class StopWidget extends StatelessWidget {
  final GestureTapCallback? onTap;

  const StopWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const Icon(size: 36, Icons.stop_circle_sharp),
    );
  }
}

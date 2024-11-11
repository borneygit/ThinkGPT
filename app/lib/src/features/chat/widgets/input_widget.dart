import 'dart:math';

import 'package:app/src/core/base/widget/circle_inkwell.dart';
import 'package:app/src/core/sessionx.dart';
import 'package:app/src/features/chat/bloc/message_send_bloc.dart';
import 'package:app/src/features/chat/bloc/session_cubit.dart';
import 'package:app/src/features/chat/commands.dart';
import 'package:app/src/features/settings/bloc/app_config_bloc.dart';
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
    final focusNode = useFocusNode();
    final layerLink = useMemoized(() => LayerLink());
    final colorScheme = Theme.of(context).colorScheme;
    final overlayEntry = useState<OverlayEntry?>(null);
    final hasText = useState(false);
    final filteredCommands = useState<List<Command>>([]);

    void showOverlay() {
      if (overlayEntry.value != null) {
        overlayEntry.value!.markNeedsBuild();
        return;
      }

      final overlay = OverlayEntry(
        builder: (context) => Positioned(
          width: 300,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            followerAnchor: Alignment.bottomLeft,
            child: Material(
              elevation: 4,
              borderRadius: borderRadius8,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: filteredCommands.value.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final command = filteredCommands.value[index];
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(children: [
                      Text(
                        command.command,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 12),
                      Text(command.description(context),
                          style: const TextStyle(color: Colors.grey)),
                    ]),
                  );
                },
              ),
            ),
          ),
        ),
      );

      overlayEntry.value = overlay;
      Overlay.of(context).insert(overlay);
    }

    void hideOverlay() {
      overlayEntry.value?.remove();
      overlayEntry.value = null;
    }

    parseCommand(String text) {
      filteredCommands.value = commands
          .where((command) => command.command.startsWith(text))
          .toList();
      showOverlay();
    }

    useEffect(() {
      void onTextChanged() {
        final text = textEditingController.text;
        hasText.value = text.isNotEmpty;
        if (text.startsWith('/')) {
          parseCommand(text);
        } else {
          hideOverlay();
          filteredCommands.value = [];
        }
      }

      textEditingController.addListener(onTextChanged);
      return () {
        textEditingController.removeListener(onTextChanged);
        hideOverlay();
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

    handleCommand(Command command, List<String> args) {
      hideOverlay();
      textEditingController.clear();
      FocusScope.of(context).requestFocus(focusNode);

      command.action.call(context, args);
    }

    bool handleCommands(String text) {
      if (filteredCommands.value.length > 1) {
        FocusScope.of(context).requestFocus(focusNode);
        return true;
      }
      if (filteredCommands.value.length == 1) {
        final command = filteredCommands.value[0];
        if (command.needArgs) {
          if (text.length <= command.command.length) {
            hideOverlay();
            textEditingController.text = "${command.command} ";
            FocusScope.of(context).requestFocus(focusNode);
          }
        } else {
          handleCommand(command, []);
        }
        return true;
      }
      if (text.startsWith('/')) {
        final texts = text.split(RegExp(r'\s+'));
        final command = commands
            .where((command) => command.command == texts[0])
            .firstOrNull;
        if (command != null) {
          handleCommand(command, texts.sublist(1));
          return true;
        }
      }

      return false;
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
              child: CompositedTransformTarget(
                link: layerLink,
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
                      if (!handleCommands(text)) {
                        sendMessage();
                      }
                    }),
              ),
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
    final appConfig = context.read<AppConfigBloc>().state;
    var active = sessionCubit.state.activeSession;
    if (active == null) {
      final session = SessionX.createSession(text, appConfig.model);
      active = await sessionCubit.upsertSession(session);
      await sessionCubit.setActiveSession(active);
    } else {
      if (active.title.isEmpty) {
        active = active.copyWith(title: text);
        await sessionCubit.upsertSession(active);
      }
    }
    final message = _createMessage(text, isUser: true, sessionId: active.id);
    messageSenderBloc.add(MessageSendEvent.sendMessage(
        message.copyWith(sessionId: active.id), active));
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

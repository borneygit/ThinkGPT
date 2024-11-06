import 'package:app/src/features/chat/bloc/session_cubit.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:resources/resources.dart';

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
          border: Border(
            right: BorderSide(color: colorScheme.primary, width: 0.5),
          ),
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

class ChatHistoryItem extends StatefulWidget {
  final Session session;
  final bool isActive;

  const ChatHistoryItem({
    super.key,
    required this.session,
    required this.isActive,
  });

  @override
  State<ChatHistoryItem> createState() => _ChatHistoryItemState();
}

class _ChatHistoryItemState extends State<ChatHistoryItem> {
  bool _isHovered = false;
  bool _isOverlayVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => setState(() => _isHovered = true)),
      onExit: (_) => setState(() => setState(() => _isHovered = false)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: widget.isActive || _isHovered || _isOverlayVisible
            ? BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: borderRadius6)
            : null,
        child: InkWell(
          onTap: () =>
              context.read<SessionCubit>().setActiveSession(widget.session),
          customBorder: const CircleBorder(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.session.title,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              if (_isHovered || _isOverlayVisible)
                MenuAnchor(
                  onOpen: () => setState(() => _isOverlayVisible = true),
                  onClose: () => setState(() => _isOverlayVisible = false),
                  style: MenuStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(theme.colorScheme.primary),
                    alignment: Alignment.bottomRight,
                    padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 12, horizontal: 4)),
                  ),
                  menuChildren: [
                    SizedBox(
                      height: 30,
                      child: MenuItemButton(
                        requestFocusOnHover: false,
                        autofocus: false,
                        leadingIcon: HugeIcon(
                          icon: HugeIcons.strokeRoundedDelete03,
                          color: theme.colorScheme.onPrimary,
                          size: 16,
                        ),
                        onPressed: () {
                          context.read<SessionCubit>().delete(widget.session);
                        },
                        style: ButtonStyle(
                          shape: const WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                            borderRadius: borderRadius6,
                          )),
                          backgroundColor:
                              WidgetStatePropertyAll(theme.colorScheme.primary),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 24,
                            ),
                            Text(IntlUtils.of(context).delete),
                          ],
                        ),
                      ),
                    ),
                  ],
                  builder: (context, controller, child) {
                    return SizedBox(
                      width: 20,
                      height: 20,
                      child: InkWell(
                        onTap: () => controller.open(),
                        child: HugeIcon(
                            icon: HugeIcons.strokeRoundedMoreHorizontal,
                            color: theme.colorScheme.onPrimary),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

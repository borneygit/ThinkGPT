import 'package:app/src/features/chat/bloc/session_cubit.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:resources/resources.dart';

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
                    MenuAnchorDelete(
                      session: widget.session,
                      parentContext: context,
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

class MenuAnchorDelete extends StatelessWidget {
  final Session session;
  final BuildContext parentContext;
  const MenuAnchorDelete(
      {super.key, required this.session, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
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
          context.read<SessionCubit>().delete(session);
        },
        style: ButtonStyle(
          shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
            borderRadius: borderRadius6,
          )),
          backgroundColor: WidgetStatePropertyAll(theme.colorScheme.primary),
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
    );
  }
}

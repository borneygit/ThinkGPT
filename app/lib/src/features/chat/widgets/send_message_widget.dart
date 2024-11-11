import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

import 'message_content_widget.dart';

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

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

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

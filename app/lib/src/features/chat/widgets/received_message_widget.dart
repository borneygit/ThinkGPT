import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resources/resources.dart';

import 'message_content_widget.dart';

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

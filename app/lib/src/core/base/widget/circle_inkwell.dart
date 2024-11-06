import 'package:flutter/material.dart';

class CircleInkWell extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double? size;
  final double? padding;

  const CircleInkWell(
      {super.key, required this.child, this.onTap, this.size, this.padding});

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? 32;
    final padding = this.padding ?? 3;

    return IconButton(
      constraints: BoxConstraints(
        maxHeight: size,
        maxWidth: size,
        minHeight: size,
        minWidth: size,
      ),
      padding: EdgeInsets.all(padding),
      alignment: Alignment.center,
      icon: child,
      onPressed: onTap,
    );
  }
}

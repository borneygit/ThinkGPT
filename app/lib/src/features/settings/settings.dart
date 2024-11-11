import 'package:app/src/features/settings/widgets/desktop/setting_window.dart';
import 'package:flutter/material.dart';

void showSettings(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            // 修改内边距
            content: SettingWindow(
              onClose: () => Navigator.of(context).pop(),
            ));
      });
}

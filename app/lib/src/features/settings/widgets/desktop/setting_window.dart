import 'package:app/src/core/base/widget/circle_inkwell.dart';
import 'package:app/src/features/settings/widgets/desktop/normal_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:resources/resources.dart';
import 'package:tuple/tuple.dart';

import 'data_setting.dart';

class SettingWindow extends HookWidget {
  final VoidCallback? onClose;

  const SettingWindow({super.key, this.onClose});

  static const _titleStyle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  List<Tuple2<IconData, String>> _settings(BuildContext context) {
    return [
      Tuple2<IconData, String>(HugeIcons.strokeRoundedSettings02,
          IntlUtils.of(context).generalConfig),
      Tuple2<IconData, String>(HugeIcons.strokeRoundedDatabaseSetting,
          IntlUtils.of(context).basicConfiguration),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final controller = usePageController();
    final selectedIndex = useState(0);
    final colorScheme = Theme.of(context).colorScheme;

    final settings = _settings(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: borderRadius8,
      ),
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(IntlUtils.of(context).settingsTitle, style: _titleStyle),
                CircleInkWell(
                  onTap: onClose,
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    color: colorScheme.onSecondary,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          normalDivider,
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: edgeInsets8,
                    child: ListView.builder(
                      itemCount: settings.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: selectedIndex.value == index
                                ? colorScheme.secondaryContainer
                                : Colors.transparent,
                            borderRadius: borderRadius6,
                          ),
                          child: InkWell(
                            onTap: () {
                              selectedIndex.value = index;
                              controller.jumpToPage(index);
                            },
                            child: Padding(
                              padding: edgeInsetsH10V8,
                              child: Row(
                                children: [
                                  HugeIcon(
                                    icon: settings[index].item1,
                                    color: colorScheme.onPrimary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    settings[index].item2,
                                    style: TextStyle(
                                        color: colorScheme.onSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller,
                    itemCount: settings.length,
                    onPageChanged: (index) => selectedIndex.value = index,
                    itemBuilder: (context, index) {
                      switch (index) {
                        case 0:
                          return const NormalSettingPage();
                        case 1:
                          return const DataSettingPage();
                      }
                      return Container(); // 这里添加对应页面的内容
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:app/src/features/settings/bloc/app_config_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:resources/resources.dart';

class NormalSettingPage extends StatelessWidget {
  const NormalSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      const ThemeItem(),
      const LanguageItem(),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: ListView.separated(
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: items[index]);
          },
          separatorBuilder: (context, index) => normalDivider,
          itemCount: items.length),
    );
  }
}

class ThemeItem extends HookWidget {
  const ThemeItem({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<AppConfigBloc>().state.themeMode;
    final colorScheme = Theme.of(context).colorScheme;
    final themeMap = _getThemeMap(context);
    return Row(children: [
      Text(IntlUtils.of(context).theme,
          style: TextStyle(color: colorScheme.onSecondary)),
      const Spacer(),
      MenuAnchor(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
          alignment: Alignment.bottomLeft,
          padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 12, horizontal: 4)),
        ),
        menuChildren: themeMap.entries.map((e) {
          final isSelected = e.key == themeMode;
          return SizedBox(
            height: 30,
            child: MenuItemButton(
              autofocus: isSelected,
              requestFocusOnHover: false,
              style: ButtonStyle(
                shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: borderRadius6,
                )),
                backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
              ),
              trailingIcon: HugeIcon(
                icon: HugeIcons.strokeRoundedCheckmarkCircle02,
                color: isSelected
                    ? colorScheme.onPrimary
                    : colorScheme.onPrimary.withOpacity(0.4),
                size: 16,
              ),
              onPressed: () {
                context.read<AppConfigBloc>().setTheme(e.key);
              },
              child: Wrap(
                children: [
                  Text(e.value),
                  const SizedBox(
                    width: 50,
                  )
                ],
              ),
            ),
          );
        }).toList(),
        builder: (context, controller, child) {
          return Material(
            color: colorScheme.primary,
            child: InkWell(
              onTap: () {
                controller.open();
              },
              hoverColor: colorScheme.secondaryContainer,
              borderRadius: borderRadius6,
              child: Padding(
                padding: edgeInsetsH8V4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(themeMap[themeMode]!),
                    const SizedBox(width: 4),
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      color: colorScheme.onPrimary,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ]);
  }

  Map<ThemeMode, String> _getThemeMap(BuildContext context) {
    return {
      ThemeMode.system: IntlUtils.of(context).theme_system,
      ThemeMode.light: IntlUtils.of(context).theme_light,
      ThemeMode.dark: IntlUtils.of(context).theme_dark,
    };
  }
}

class LanguageItem extends StatelessWidget {
  const LanguageItem({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final language = context.watch<AppConfigBloc>().state.language;
    final languageMap = _getLanguageMap(context);
    return Row(children: [
      Text(IntlUtils.of(context).language,
          style: TextStyle(color: colorScheme.onSecondary)),
      const Spacer(),
      MenuAnchor(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
          alignment: Alignment.bottomLeft,
          padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 12, horizontal: 4)),
        ),
        menuChildren: languageMap.entries.map((e) {
          final isSelected = e.key == language;
          return SizedBox(
            height: 30,
            child: MenuItemButton(
              autofocus: isSelected,
              requestFocusOnHover: false,
              style: ButtonStyle(
                shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: borderRadius6,
                )),
                backgroundColor: WidgetStatePropertyAll(colorScheme.primary),
              ),
              onPressed: () {
                context.read<AppConfigBloc>().setLanguage(e.key);
              },
              child: Wrap(
                children: [
                  Text(e.value),
                  const SizedBox(
                    width: 50,
                  )
                ],
              ),
            ),
          );
        }).toList(),
        builder: (context, controller, child) {
          return Material(
            color: colorScheme.primary,
            child: InkWell(
              onTap: () {
                controller.open();
              },
              hoverColor: colorScheme.secondaryContainer,
              borderRadius: borderRadius6,
              child: Padding(
                padding: edgeInsetsH8V4,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(languageMap[language]!),
                    const SizedBox(width: 4),
                    HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowDown01,
                      color: colorScheme.onPrimary,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ]);
  }

  Map<String, String> _getLanguageMap(BuildContext context) {
    return {
      'zh': IntlUtils.of(context).language_zh,
      'en': IntlUtils.of(context).language_en,
    };
  }
}

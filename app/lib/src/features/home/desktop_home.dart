import 'package:app/src/core/base/widget/bloc_provider_builder.dart';
import 'package:app/src/core/base/widget/circle_inkwell.dart';
import 'package:app/src/features/chat/bloc/session_cubit.dart';
import 'package:app/src/features/chat/chat_screen.dart';
import 'package:app/src/features/chat/widgets/chat_history_window.dart';
import 'package:app/src/features/home/bloc/sidebar_cubit.dart';
import 'package:app/src/features/home/widgets/desktop_window.dart';
import 'package:app/src/features/settings/widgets/desktop/setting_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

class DesktopHomeScreen extends StatelessWidget {
  const DesktopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DesktopWindow(
        child: BlocProviderBuilder<SideBarCubit, bool>(
          create: (context) => SideBarCubit(),
          builder: (BuildContext context, bool isSidebarExpanded) {
            return Column(
              children: [
                const ToolBar(),
                Expanded(
                  child: Row(
                    children: [
                      const SideBar(),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: isSidebarExpanded ? 200.0 : 0.0,
                        height: double.infinity,
                        child: const ClipRect(
                          child: ChatHistoryWindow(),
                        ),
                      ),
                      const Expanded(child: ChatScreen()),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ToolBar extends StatelessWidget {
  const ToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 36,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colorScheme.secondary, width: 1),
        ),
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSidebarExpanded = context.watch<SideBarCubit>().isSidebarExpanded;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      width: 36,
      height: double.infinity,
      decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: colorScheme.secondary, width: 0.5),
          ),
          gradient: LinearGradient(
            colors: [colorScheme.primary, colorScheme.secondary],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  CircleInkWell(
                    onTap: () => context.read<SideBarCubit>().toggleSideBar(),
                    child: HugeIcon(
                      icon: isSidebarExpanded
                          ? HugeIcons.strokeRoundedSidebarLeft01
                          : HugeIcons.strokeRoundedSidebarRight01,
                      color: colorScheme.onPrimary,
                      size: 22,
                    ),
                  ),
                  CircleInkWell(
                    onTap: () =>
                        context.read<SessionCubit>().setActiveSession(null),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedBubbleChatAdd,
                      color: colorScheme.onPrimary,
                      size: 22,
                    ),
                  )
                ],
              )),
          Expanded(
              flex: 1,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                CircleInkWell(
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedSettings01,
                      color: colorScheme.onPrimary,
                      size: 22,
                    ),
                    onTap: () {
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
                    }),
              ])),
        ],
      ),
    );
  }
}

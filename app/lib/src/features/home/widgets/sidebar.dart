import 'package:app/src/core/base/widget/circle_inkwell.dart';
import 'package:app/src/features/chat/bloc/session_cubit.dart';
import 'package:app/src/features/home/bloc/sidebar_cubit.dart';
import 'package:app/src/features/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';

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
                    onTap: () => _createSession(context),
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
                      showSettings(context);
                    }),
              ])),
        ],
      ),
    );
  }

  void _createSession(BuildContext context) async {
    context.read<SessionCubit>().setActiveSession(null);
  }
}

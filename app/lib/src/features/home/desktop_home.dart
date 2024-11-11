import 'package:app/src/core/base/widget/bloc_provider_builder.dart';
import 'package:app/src/features/chat/chat_screen.dart';
import 'package:app/src/features/chat/widgets/chat_history_window.dart';
import 'package:app/src/features/home/bloc/sidebar_cubit.dart';
import 'package:app/src/features/home/widgets/desktop_window.dart';
import 'package:flutter/material.dart';

import 'widgets/sidebar.dart';
import 'widgets/toolbar.dart';

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

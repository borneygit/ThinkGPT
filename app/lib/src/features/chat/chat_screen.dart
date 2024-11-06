import 'package:app/src/features/chat/bloc/message_send_bloc.dart';
import 'package:app/src/features/chat/bloc/messages_cubit.dart';
import 'package:app/src/features/chat/bloc/session_cubit.dart';
import 'package:app/src/features/chat/widgets/chat_message_list.dart';
import 'package:app/src/features/chat/widgets/input_widget.dart';
import 'package:app/src/features/settings/bloc/app_config_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:resources/resources.dart';
import 'package:shared/shared.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<MessageCubit>()),
        BlocProvider(create: (context) => getIt<MessageSenderBloc>()),
      ],
      child: BlocBuilder<SessionCubit, SessionState>(
        buildWhen: (previous, current) {
          final previousSession = previous.activeSession;
          final currentSession = current.activeSession;
          return previousSession?.id != currentSession?.id;
        },
        builder: (context, state) {
          String language = context.read<AppConfigBloc>().state.language;
          return Container(
              color: Theme.of(context).colorScheme.surface,
              child: state.activeSession == null
                  ? EmptySessionWidget(key: ValueKey<String>(language))
                  : const ActiveSessionWidget());
        },
      ),
    );
  }
}

class EmptySessionWidget extends HookWidget {
  const EmptySessionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final characters = useState<List<String>>([]);
    final currentIndex = useState(0);
    final message = IntlUtils.of(context).helpAssistant;

    useEffect(() {
      void animateText() {
        Future.delayed(const Duration(milliseconds: 26), () {
          if (currentIndex.value < message.length) {
            characters.value = [
              ...characters.value,
              message[currentIndex.value]
            ];
            currentIndex.value++;
            animateText();
          }
        });
      }

      animateText();
      return null; // Clean up (if needed)
    }, []);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 56),
            child: Text(
              characters.value.join(),
              key: ValueKey<String>(IntlUtils.of(context).helpAssistant),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 48),
          const InputWidget(),
        ],
      ),
    );
  }
}

class ActiveSessionWidget extends StatelessWidget {
  const ActiveSessionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      Expanded(
        child: ChatMessageList(),
      ),
      InputWidget()
    ]);
  }
}

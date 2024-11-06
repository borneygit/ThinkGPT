import 'package:app/src/features/settings/bloc/app_config_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:resources/resources.dart';

class DataSettingPage extends HookWidget {
  static const _itemHintTextStyle = TextStyle(color: Colors.grey, fontSize: 14);

  const DataSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final config = context.read<AppConfigBloc>().state;
    final apiKeyController = useTextEditingController(text: config.apiKey);
    final baseUrlController = useTextEditingController(text: config.baseUrl);
    final isApiKeyVisible = useState(false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            itemCount: 2,
            separatorBuilder: (context, index) => normalDivider,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return TextField(
                    maxLines: 1,
                    cursorHeight: 14,
                    obscureText: !isApiKeyVisible.value,
                    controller: apiKeyController,
                    cursorColor: colorScheme.onPrimary,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      label: Text('Api Key',
                          style: TextStyle(
                              color: colorScheme.onPrimary, fontSize: 14)),
                      hintText: 'Please enter your api key',
                      hintStyle: _itemHintTextStyle,
                      suffixIcon: IconButton(
                          icon: Icon(
                            isApiKeyVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: 16,
                            color: colorScheme.onPrimary,
                          ),
                          onPressed: () {
                            isApiKeyVisible.value = !isApiKeyVisible.value;
                          }),
                    ),
                    style:
                        TextStyle(color: colorScheme.onPrimary, fontSize: 14),
                    onSubmitted: (text) {
                      context.read<AppConfigBloc>().setApiKey(text);
                    },
                  );
                case 1:
                  return TextField(
                    maxLines: 1,
                    cursorHeight: 14,
                    controller: baseUrlController,
                    cursorColor: colorScheme.onPrimary,
                    decoration: InputDecoration(
                      label: Text('Base Url',
                          style: TextStyle(
                              color: colorScheme.onPrimary, fontSize: 14)),
                      border: InputBorder.none,
                      hintText: 'Please enter your base url',
                      hintStyle: _itemHintTextStyle,
                    ),
                    style:
                        TextStyle(color: colorScheme.onPrimary, fontSize: 14),
                    onSubmitted: (text) {
                      context.read<AppConfigBloc>().setBaseUrl(text);
                    },
                  );
              }
              return null;
            },
          )),
    );
  }
}

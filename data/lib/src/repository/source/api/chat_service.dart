import 'package:dart_openai/dart_openai.dart';
import 'package:domain/domain.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChatService {
  final SettingRepository _settingRepository;

  ChatService(this._settingRepository);

  Future<String> sendMessage(Message sendMessage) async {
    OpenAI.baseUrl = await _settingRepository.getBaseUrl();
    OpenAI.apiKey = await _settingRepository.getApiKey();
    final response =
        await OpenAI.instance.chat.create(model: 'o1-mini', messages: [
      OpenAIChatCompletionChoiceMessageModel(
          role: OpenAIChatMessageRole.user,
          content: [
            OpenAIChatCompletionChoiceMessageContentItemModel.text(
                sendMessage.content)
          ])
    ]);
    final message = response.choices.first.message;
    if (message.haveContent) {
      final text = message.content!.first.text ?? '';
      return text;
    }
    return '';
  }

  Stream<String> streamChat(List<Message> messages, String model) async* {
    OpenAI.baseUrl = await _settingRepository.getBaseUrl();
    OpenAI.apiKey = await _settingRepository.getApiKey();
    final stream = OpenAI.instance.chat.createStream(
        model: model,
        messages: messages.map((m) {
          return OpenAIChatCompletionChoiceMessageModel(
              role: m.isUser
                  ? OpenAIChatMessageRole.user
                  : OpenAIChatMessageRole.assistant,
              content: [
                OpenAIChatCompletionChoiceMessageContentItemModel.text(
                    m.content)
              ]);
        }).toList());
    await for (final res in stream) {
      if (res.choices.isNotEmpty) {
        final text = res.choices.first.delta.content?.first?.text;
        if (text != null) {
          yield text;
        }
      }
    }
  }
}

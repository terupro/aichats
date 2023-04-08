import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class AIHandler {
  final _openAI = OpenAI.instance.build(
    token: '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',
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
    ),
  );

  Future<String> getResponse(String message) async {
    try {
      final request = ChatCompleteText(messages: [
        Map.of({"role": "user", "content": message})
      ], maxToken: 200, model: ChatModel.ChatGptTurbo0301Model);

      final response = await _openAI.onChatCompletion(request: request);
      if (response != null) {
        return response.choices[0].message.content.trim();
      }

      return '問題が発生したようです。しばらくしてからもう一度お試しください。';
    } catch (e) {
      return '問題が発生したようです。しばらくしてからもう一度お試しください。';
    }
  }

  void dispose() {
    _openAI.close();
  }
}

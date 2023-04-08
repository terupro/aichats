import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIHandler {
  final _openAI = OpenAI.instance.build(
    token: dotenv.env['API_KEY']!,
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 60),
      connectTimeout: const Duration(seconds: 60),
    ),
  );

  Future<String> getResponse(String message) async {
    try {
      final request = ChatCompleteText(
        messages: [
          Map.of({
            "role": "user",
            "content": message,
          })
        ],
        temperature: 0.7,
        maxToken: 200,
        model: ChatModel.ChatGptTurbo0301Model,
      );

      final response = await _openAI.onChatCompletion(request: request);
      if (response != null) {
        return response.choices[0].message.content.trim();
      }

      return '問題が発生しました。しばらくしてから再度お試しください。';
    } catch (e) {
      return '問題が発生しました。しばらくしてから再度お試しください。';
    }
  }

  void dispose() {
    _openAI.close();
  }
}

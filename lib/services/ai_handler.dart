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

  List<Map<String, String>> _messageHistory;

  AIHandler() : _messageHistory = [];

  Future<String> getResponse(String message) async {
    try {
      _messageHistory.add({
        "role": "system",
        "content":
            "あなたは親しみやすくフレンドリーなAIアシスタントです。会話の中でユーモアを交えつつ、ユーザーに対して助けになるような回答を提供してください。",
      });
      _messageHistory.add({
        "role": "user",
        "content": message,
      });

      final request = ChatCompleteText(
        messages: _messageHistory,
        temperature: 0.5,
        presencePenalty: 0.2,
        maxToken: 400,
        model: ChatModel.ChatGptTurbo0301Model,
      );

      final response = await _openAI.onChatCompletion(request: request);
      if (response != null) {
        String assistantResponse = response.choices[0].message.content.trim();
        _messageHistory
            .add({"role": "assistant", "content": assistantResponse});
        return assistantResponse;
      }
      return '問題が発生しました。しばらくしてから再度お試しください。';
    } catch (e) {
      print('エラーが発生しました: ${e.toString()}');
      return '問題が発生しました。しばらくしてから再度お試しください。';
    }
  }

  void dispose() {
    _openAI.close();
    _messageHistory.clear();
  }
}

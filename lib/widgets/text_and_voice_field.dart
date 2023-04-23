import 'package:aichats/providers/chats_provider.dart';
import 'package:aichats/screens/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat_model.dart';
import '../services/ai_handler.dart';
import '../services/voice_handler.dart';
import 'toggle_button.dart';

const _chatCountKey = 'chat_count';

enum InputMode {
  text,
  voice,
}

class TextAndVoiceField extends ConsumerStatefulWidget {
  const TextAndVoiceField({Key? key}) : super(key: key);

  @override
  ConsumerState<TextAndVoiceField> createState() => _TextAndVoiceFieldState();
}

class _TextAndVoiceFieldState extends ConsumerState<TextAndVoiceField>
    with TickerProviderStateMixin {
  InputMode _inputMode = InputMode.voice;
  final _messageController = TextEditingController();
  final AIHandler _openAI = AIHandler();
  final VoiceHandler voiceHandler = VoiceHandler();
  var _isReplying = false;
  var _isListening = false;
  bool isSubscribed = false;

  late AnimationController _typingAnimationController;
  late Animation<double> _typingAnimation;

  @override
  void initState() {
    voiceHandler.initSpeech();
    _loadChatHistory();

    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _typingAnimation =
        Tween<double>(begin: 0, end: 1).animate(_typingAnimationController);
    // 顧客が契約内容を変更するたびに呼び出す
    Purchases.addCustomerInfoUpdateListener((_) => updateCustomerStatus());
    updateCustomerStatus();
  }

  Future updateCustomerStatus() async {
    final customerInfo = await Purchases.getCustomerInfo();
    setState(() {
      // アクセス権のあるものだけ取得する
      final entitlement = customerInfo.entitlements.active['unlimited_chat'];
      // アクセス権があるかどうかを確認する
      isSubscribed = entitlement != null;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _typingAnimationController.dispose();
    _openAI.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  minLines: 1,
                  maxLines: 4,
                  controller: _messageController,
                  onChanged: (value) {
                    value.isNotEmpty
                        ? setInputMode(InputMode.text)
                        : setInputMode(InputMode.voice);
                  },
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  decoration: InputDecoration(
                    hintText: 'メッセージを入力...',
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          top: 0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
            height: MediaQuery.of(context).size.height * 0.08,
            child: ToggleButton(
              isListening: _isListening,
              isReplying: _isReplying,
              inputMode: _inputMode,
              sendTextMessage: () {
                final message = _messageController.text;
                _messageController.clear();
                sendTextMessage(message);
              },
              sendVoiceMessage: sendVoiceMessage,
            ),
          ),
        ),
      ],
    );
  }

  void setInputMode(InputMode inputMode) {
    setState(() {
      _inputMode = inputMode;
    });
  }

  void sendVoiceMessage() async {
    if (!voiceHandler.isEnabled) {
      return;
    }
    if (voiceHandler.speechToText.isListening) {
      await voiceHandler.stopListening();
      setListeningState(false);
    } else {
      setListeningState(true);
      final result = await voiceHandler.startListening();
      setListeningState(false);
      sendTextMessage(result);
    }
  }

  void sendTextMessage(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int chatCount = prefs.getInt(_chatCountKey) ?? 0;
    if (chatCount > 1 && !isSubscribed) {
      subscriptionScreen(context);
      return;
    } else {
      if (!isSubscribed) {
        chatCount++;
        await prefs.setInt(_chatCountKey, chatCount);
      }
      setReplyingState(true);
      addToChatList(message, true, DateTime.now().toString());
      addToChatList('...', false, 'typing');
      setInputMode(InputMode.voice);
      final aiResponse = await _openAI.getResponse(message);
      removeTyping();
      addToChatList(aiResponse, false, DateTime.now().toString());
      setReplyingState(false);
    }
  }

  void setReplyingState(bool isReplying) {
    setState(() {
      _isReplying = isReplying;
    });
  }

  void setListeningState(bool isListening) {
    setState(() {
      _isListening = isListening;
    });
  }

  void removeTyping() {
    final chats = ref.read(chatsProvider.notifier);
    chats.removeTyping();
  }

  void addToChatList(String message, bool isMe, String id) {
    final chats = ref.read(chatsProvider.notifier);
    chats.add(ChatModel(
      id: id,
      message: message,
      isMe: isMe,
      typingAnimation: _typingAnimation,
    ));
  }

  void saveMessageToPrefs(String message, bool isMe, String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chatHistory = prefs.getStringList('chat_history') ?? [];

    chatHistory.add(id);
    chatHistory.add(message);
    chatHistory.add(isMe.toString());

    await prefs.setStringList('chat_history', chatHistory);
  }

  void _loadChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chatHistory = prefs.getStringList('chat_history') ?? [];

    for (int i = 0; i < chatHistory.length; i += 3) {
      addToChatList(
          chatHistory[i + 1], chatHistory[i + 2] == 'true', chatHistory[i]);
    }
  }
}

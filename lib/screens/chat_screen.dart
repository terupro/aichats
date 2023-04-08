import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chats_provider.dart';
import '../widgets/chat_item.dart';

import '../widgets/my_app_bar.dart';
import '../widgets/text_and_voice_field.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MyAppBar(scaffoldKey: _scaffoldKey),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                      child: Icon(
                        Icons.chat_bubble_outline,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'AIChats',
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Powered by ChatGPT',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('アプリをシェアする'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('プライバシーポリシー'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('利用規約'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.star_outline),
                title: const Text('プレミアムプランに登録する'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('ヘルプ＆サポート'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer(builder: (context, ref, child) {
                final chats = ref.watch(chatsProvider).reversed.toList();
                return ListView.builder(
                  reverse: true,
                  itemCount: chats.length,
                  itemBuilder: (context, index) => ChatItem(
                    text: chats[index].message,
                    isMe: chats[index].isMe,
                  ),
                );
              }),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: TextAndVoiceField(),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

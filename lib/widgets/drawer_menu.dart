import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  backgroundColor: Theme.of(context).colorScheme.onSecondary,
                  child: Icon(
                    CupertinoIcons.chat_bubble_2,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 48,
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
                        .onSecondary
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
              _shareApp();
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
    );
  }

  void _shareApp() async {
    await Share.share(
        'AIChatsアプリで手軽にAIと会話しよう！言語やトピックを選んで、いつでもどこでも会話ができます。友達や家族と共有して、みんなでAIとの会話を楽しんでみませんか？シェアリンクはこちら：https://example.com/aichats」 https://example.com/aichats');
  }
}

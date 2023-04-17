import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri policyUrl = Uri.parse(
    'https://celestial-clam-8a3.notion.site/a5c323e0053d4bda88a1584a2f941fce');

final Uri ruleUrl = Uri.parse(
    'https://celestial-clam-8a3.notion.site/d5d75deaea7d442293b4d3eb75868a02');

final Uri helpUrl = Uri.parse(
    'https://celestial-clam-8a3.notion.site/AIChats-4294b075a76341d8955ec3374aa5f8db');

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
                SvgPicture.asset(
                  "assets/images/logo.svg",
                  color: Theme.of(context).colorScheme.onSecondary,
                  height: 60,
                ),
                const SizedBox(height: 4),
                Text(
                  'AIChats',
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Powered by ChatGPT',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondary
                        .withOpacity(0.6),
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
            onTap: _launchPolicyUrl,
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('利用規約'),
            onTap: _launchRuleUrl,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('ヘルプ＆サポート'),
            onTap: _launchHelpUrl,
          ),
        ],
      ),
    );
  }

  void _shareApp() async {
    await Share.share(
        'AIChatsアプリで手軽にAIと会話しよう！最先端AIと、音声やテキストを使って会話できます。友達や家族と共有して、みんなでAIとの会話を楽しんでみませんか？シェアリンクはこちら：https://example.com/aichats」 https://example.com/aichats');
  }

  Future<void> _launchPolicyUrl() async {
    if (!await launchUrl(policyUrl)) {
      throw Exception('無効なURLです。');
    }
  }

  Future<void> _launchRuleUrl() async {
    if (!await launchUrl(ruleUrl)) {
      throw Exception('無効なURLです。');
    }
  }

  Future<void> _launchHelpUrl() async {
    if (!await launchUrl(helpUrl)) {
      throw Exception('無効なURLです。');
    }
  }
}

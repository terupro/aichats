import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/urls.dart';

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
              shareApp();
            },
          ),
          const ListTile(
            leading: Icon(Icons.privacy_tip_outlined),
            title: Text('プライバシーポリシー'),
            onTap: launchPolicyUrl,
          ),
          const ListTile(
            leading: Icon(Icons.description_outlined),
            title: Text('利用規約'),
            onTap: launchRuleUrl,
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('ヘルプ＆サポート'),
            onTap: launchHelpUrl,
          ),
        ],
      ),
    );
  }
}

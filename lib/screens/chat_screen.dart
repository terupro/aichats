import 'package:aichats/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/chats_provider.dart';
import '../widgets/chat_item.dart';

import '../widgets/my_app_bar.dart';
import '../widgets/text_and_voice_field.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _showTutorial(context));
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: MyAppBar(scaffoldKey: _scaffoldKey),
        drawer: const DrawerMenu(),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Consumer(builder: (context, ref, child) {
                    final chats = ref.watch(chatsProvider).reversed.toList();
                    return chats.isNotEmpty
                        ? ListView.builder(
                            reverse: true,
                            itemCount: chats.length,
                            itemBuilder: (context, index) => ChatItem(
                              text: chats[index].message,
                              isMe: chats[index].isMe,
                            ),
                          )
                        : _buildEmptyMessageUI(context);
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
          ],
        ),
      ),
    );
  }

  Future<void> _showTutorial(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasSeenTutorial = prefs.getBool('seen_tutorial');

    if (hasSeenTutorial == null || !hasSeenTutorial) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'AIChatsの使い方',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('1. テキスト入力欄にメッセージを入力し、送信ボタンを押して会話を開始します。'),
                SizedBox(height: 8.0),
                Text('2. 音声入力を利用する場合は、マイクアイコンをタップして話しかけてください。'),
                SizedBox(height: 8.0),
                Text('3. お天気ボタンを押して、ライトモードとダークモードの切り替えができます。'),
                SizedBox(height: 8.0),
                Text('4. メニューボタンを押して、設定やヘルプなどのオプションにアクセスできます。'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await prefs.setBool('seen_tutorial', true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.secondary, // ボタンの背景色
                foregroundColor: Colors.white, // ボタンのフォントカラー
              ),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildEmptyMessageUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/images/logo.svg",
          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.4),
          height: 100,
        ),
        Text(
          "チャットを始めよう",
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.4),
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

import 'package:aichats/widgets/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/chats_provider.dart';
import '../widgets/chat_item.dart';
import '../widgets/my_app_bar.dart';
import '../widgets/text_and_voice_field.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({Key? key}) : super(key: key);

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      child: GestureDetector(
        onTap: _focusNode.requestFocus,
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
                                message: chats[index].message,
                                isMe: chats[index].isMe,
                                typingAnimation: chats[index].typingAnimation,
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
      ),
    );
  }

  Widget _buildEmptyMessageUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
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
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}

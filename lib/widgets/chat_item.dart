import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatItem extends StatelessWidget {
  final String text;
  final bool isMe;
  const ChatItem({
    Key? key,
    required this.text,
    required this.isMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ProfileContainer(isMe: isMe),
          if (!isMe) const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            decoration: BoxDecoration(
              color: isMe
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey.shade800,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SelectableText(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 16, // テキストのフォントサイズを調整
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 12),
          if (isMe) ProfileContainer(isMe: isMe),
        ],
      ),
    );
  }
}

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({
    Key? key,
    required this.isMe,
  }) : super(key: key);
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isMe
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20), // ボーダーの角を丸くする
      ),
      child: isMe
          ? Icon(
              Icons.face,
              color: Theme.of(context).colorScheme.onSecondary,
              size: 26,
            )
          : SvgPicture.asset(
              'assets/images/ai.svg',
              color: Theme.of(context).colorScheme.onSecondary,
              height: 34, // アイコンのサイズを調整
            ),
    );
  }
}

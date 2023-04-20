import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void subScriptionScreen(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Container(
        margin: EdgeInsets.only(top: 64),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              // サブスクリプションの状態を保存
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setBool('is_subscribed', true);

              // モーダルを閉じる
              Navigator.pop(context);
            },
            child: const Text('サブスクリプション'),
          ),
        ),
      );
    },
  );
}

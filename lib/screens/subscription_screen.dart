import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ai_handler.dart';

void showCustomModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return Container(
        margin: const EdgeInsets.only(top: 64),
        decoration: BoxDecoration(
          color: Color(0xFF303030),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/onboarding_2.png',
                height: 300,
              ),
              const SizedBox(height: 16),
              Text(
                '無制限のメッセージを解除',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '今すぐ登録して、AIチャットへの無制限アクセスをお楽しみください。',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 32),
              CupertinoButton(
                onPressed: () async {
                  // サブスクリプションに登録する
                  try {
                    await Purchases.purchaseProduct(
                      'net.terupro.aichats.subscription',
                    );
                  } catch (e) {
                    debugPrint('製品の購入に失敗しました。');
                  }
                },
                color: Theme.of(context).colorScheme.secondary,
                child: Text(
                  '登録する',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

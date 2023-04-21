import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomModalBottomSheet extends StatefulWidget {
  const CustomModalBottomSheet({Key? key}) : super(key: key);
  @override
  _CustomModalBottomSheetState createState() => _CustomModalBottomSheetState();
}

class _CustomModalBottomSheetState extends State<CustomModalBottomSheet> {
  bool isSubscribed = false;
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 64),
      decoration: const BoxDecoration(
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
            Icon(isSubscribed ? Icons.paid : Icons.lock),
            Image.asset(
              'assets/images/onboarding_2.png',
              height: 300,
            ),
            const SizedBox(height: 16),
            Text(
              "AIチャットの無制限アクセス",
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
                try {
                  await Purchases.purchaseProduct(
                      'net.terupro.aichats.subscription');
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('isSubscribed', true);
                  Navigator.pop(context);
                } catch (e) {
                  debugPrint('サブスク登録に失敗しました');
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
  }
}

void showCustomModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return const CustomModalBottomSheet();
    },
  );
}

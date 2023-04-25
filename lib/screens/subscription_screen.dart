import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:aichats/utils/urls.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({Key? key}) : super(key: key);
  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          margin: const EdgeInsets.only(top: 20),
          decoration: const BoxDecoration(
            color: Color(0xFF303030),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/subscription.png',
                        height: MediaQuery.of(context).size.height * 0.35,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "回数制限なしで、\nチャットAIを使いこなそう。",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '最初の3日間は無料。いつでもキャンセル可能',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondary
                            .withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _subscribe,
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        child: Text(
                          '無料で始める',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "そのあとは${formatNumberWithCommas(1280)}/月",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: launchPolicyUrl,
                          child: Text(
                            'プライバシーポリシー',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: launchRuleUrl,
                          child: Text(
                            '利用規約',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _restorePurchases,
                          child: Text(
                            '復元',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String formatNumberWithCommas(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  Future<void> _subscribe() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Purchases.purchaseProduct('net.terupro.aichats.subscription');
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isSubscribed', true);
      Navigator.pop(context);
    } catch (e) {
      debugPrint('サブスク登録に失敗しました');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _restorePurchases() async {
    try {
      setState(() {
        isLoading = true;
      });
      final entitlements = await Purchases.restorePurchases();
      if (entitlements.activeSubscriptions.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isSubscribed', true);
        Navigator.pop(context);
      } else {
        showRestoreDialog(context);
      }
    } catch (e) {
      debugPrint('購入履歴の復元に失敗しました');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

void subscriptionScreen(BuildContext context) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return const CustomBottomSheet();
    },
  );
}

void showRestoreDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoTheme(
        data: const CupertinoThemeData(brightness: Brightness.light),
        child: CupertinoAlertDialog(
          title: const Text('購入の復元', style: TextStyle(fontSize: 16)),
          content:
              const Text('復元できる購入がありませんでした。', style: TextStyle(fontSize: 12)),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
